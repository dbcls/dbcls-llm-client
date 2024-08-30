library(ggplot2)
library(Rtsne)
library(dplyr)
library(stringr)
library(wordcloud)
library(tidytext)

# analysis of questions
txt.dat <- read.csv("benchmark_embed_96009_files/all_txt.csv")

reviews_tidy <- txt.dat %>%
  unnest_tokens("Word", "question") %>%
  anti_join(stop_words, by = c("Word" = "word")) %>%
  mutate(Word = str_replace(Word, "'s", ""))

word_frequency <- function(x, top = 10){
  x %>%
    count(Word, sort = TRUE) %>%
    mutate(Word = factor(Word, levels = rev(unique(Word)))) %>% 
    top_n(top) %>%
    ungroup() %>%
    
    # The graph itself
    ggplot(mapping = aes(x = Word, y = n)) +
    geom_col(show.legend = FALSE) +
    coord_flip() +
    labs(x = NULL) +
    theme_bw()
}

# tidy length
txt.dat$question_tidy_len <- 0
for (dn in unique(txt.dat$datanum)){
  txt.dat[txt.dat$datanum == dn,]$question_tidy_len <- length(reviews_tidy[reviews_tidy$datanum == dn,"Word"])
}
summary(txt.dat$question_tidy_len)
ggplot(txt.dat, aes(x=question_tidy_len)) +
  geom_histogram() +
  xlab("Length of prompts") +
  ggtitle("Histogram of the pre-filtered Prompt Lengths (n=571)") +
  theme_bw()

KEEP_MSG_KEYS = c("bioinformatics","biology","microbiology","notype","genus","phylum","taxonomy","prokaryote","bacteria","fungi","fungal","virus","eukaryote","gene")
add_virus <- c('viruses','retrovirus','retroviruses','coronavirus','paramyxovirus')
add_bacteria <- c('bacterial')

KEEP_MSG_KEYS_plus <- c(KEEP_MSG_KEYS,add_virus,add_bacteria)
txt.dat$question_tidy_type_plus <- "other"
for (dn in unique(txt.dat$datanum)){
  if (sum(KEEP_MSG_KEYS_plus %in% reviews_tidy[reviews_tidy$datanum == dn,"Word"]) == 1) {
    txt.dat[txt.dat$datanum == dn,]$question_tidy_type_plus <- KEEP_MSG_KEYS_plus[which(KEEP_MSG_KEYS_plus %in% reviews_tidy[reviews_tidy$datanum == dn,"Word"])]
  }
  else if (sum(KEEP_MSG_KEYS_plus %in% reviews_tidy[reviews_tidy$datanum == dn,"Word"]) > 1) {
    txt.dat[txt.dat$datanum == dn,]$question_tidy_type_plus <- "multi"
  }
}
# View(txt.dat[,c("question","question_type","question_tidy_type")])
View(txt.dat[txt.dat$question_tidy_type_plus == "other",c("datanum","question","question_type","question_tidy_type","question_tidy_type_plus")])
focus = 'data_32245'
txt.dat[txt.dat$datanum == focus,"question"]
reviews_tidy[reviews_tidy$datanum == "data_439","Word"]
txt.dat[txt.dat$question_tidy_type_plus %in% add_virus,]$question_tidy_type_plus <- "virus"
txt.dat[txt.dat$question_tidy_type_plus %in% add_bacteria,]$question_tidy_type_plus <- "bacteria"
txt.dat[txt.dat$question_tidy_type_plus == "fungal",]$question_tidy_type_plus <- "fungi"
table(txt.dat$question_tidy_type_plus)

# word cloud
word.df <- data.frame(table(txt.dat$question_tidy_type_plus))
wordcloud(words = word.df$Var1, freq = word.df$Freq, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35,
          colors = brewer.pal(8, "Dark2"))

# analysis of sentence transformer 
num.dat <- read.csv("benchmark_embed_96009_files/all_num.csv")
num.dat <- num.dat[,-1]

mat.df <- data.frame()
for (dn in non_other) {
  tmp <- t(data.frame(num.dat[num.dat$datanum == dn,"prompt"]))
  rownames(tmp) <- dn
  mat.df <- rbind.data.frame(mat.df, tmp)
}
mat.uq <- unique(as.matrix(mat.df))

# t-SNE
tsne_out <- Rtsne(mat.uq)

# plot
tsne_plot <- data.frame(x = tsne_out$Y[,1], 
                        y = tsne_out$Y[,2],
                        datanum = txt.dat[txt.dat$datanum %in% rownames(mat.uq),"datanum"],
                        tidy_type_plus = txt.dat[txt.dat$datanum %in% rownames(mat.uq),"question_tidy_type_plus"])
ggsave('benchmark_embed_96009_files/prompt_tSNE_tidytype.pdf',width = 7,height=5,dpi=300,units = "in")
ggplot(tsne_plot,label=datanum) + 
  geom_point(aes(x=x,y=y,color=tidy_type_plus),size=2,alpha=0.8) +
  ggtitle("t-SNE of the unique prompts (n=137)") +
  scale_color_brewer(palette = "Set1") +
  xlab("Dimension1") +
  ylab("Dimension2") +
  theme_bw() +
  theme(
    legend.title = element_blank()
  )
ggsave('benchmark_embed_96009_files/prompt_tSNE_tidytypeplus.png',width = 7,height=5,dpi=300,units = "in")

# virus group
tsne_plot[tsne_plot$x<(-5) & tsne_plot$y<(-2.5),"datanum"]
txt.dat[txt.dat$datanum %in% tsne_plot[tsne_plot$x<(-5) & tsne_plot$y<(-2.5),"datanum"],"question"]

reviews_tidy[reviews_tidy$datanum %in% tsne_plot[tsne_plot$x<(-5) & tsne_plot$y<(-2.5),"datanum"],] %>%
  group_by(datanum) %>% 
  word_frequency(10) +
  facet_wrap(~ datanum, scales = "free_y")

# euclidean distance between plot
dist.mat <- as.matrix(dist(tsne_plot[,c(1,2)], method = "euclidean",
                           diag = TRUE, upper = FALSE))
rownames(dist.mat) <- tsne_plot$datanum
colnames(dist.mat) <- tsne_plot$datanum

row_ann <- data.frame(tsne_plot$tidy_type_plus)
rownames(row_ann) <- tsne_plot$datanum

library(pheatmap)
out <- pheatmap(dist.mat,
                annotation_row = row_ann,
                annotation_col = row_ann)
save_pheatmap_pdf <- function(x, filename, width=25, height=20) {
  stopifnot(!missing(x))
  stopifnot(!missing(filename))
  if(grepl(".png",filename)){
    png(filename, width=width, height=height, units = "in", res=300)
    grid::grid.newpage()
    grid::grid.draw(x$gtable)
    dev.off()
  }
  else if(grepl(".pdf",filename)){
    pdf(filename, width=width, height=height)
    grid::grid.newpage()
    grid::grid.draw(x$gtable)
    dev.off()
  }
  else{
    print("Filename did not contain '.png' or '.pdf'")
  }
}
save_pheatmap_pdf(out, "benchmark_embed_96009_files/pheatmap.png")

plot(out$tree_row)
abline(h=67, col="red", lty=2, lwd=2)
group <- sort(cutree(out$tree_row, h=67))
unique(group)
group[names(group) == "data_92389"] #6 group 1
group[names(group) == "data_89395"] #1 group 2
group[names(group) == "data_1643"] #4 group 3
group[names(group) == "data_15423"] #5 group 4
group[names(group) == "data_21320"] #7 group 5
group[names(group) == "data_8903"] #2 group 6
group[names(group) == "data_3637"] #3 group 7

names(group[group == 1])

group_num <- 1
reviews_tidy[reviews_tidy$datanum %in% names(group[group == group_num]),] %>%
  group_by(question_tidy_type_plus) %>%
  word_frequency(10) +
  facet_wrap(~ question_tidy_type_plus, scales = "free_y")
ggsave(paste0('benchmark_embed_96009_files/group_',group_num,'.png'),width = 7,height=5,dpi=300,units = "in")

# general freq analysis
word.df <- data.frame(table(reviews_tidy$Word))
wordcloud(words = word.df$Var1, freq = word.df$Freq, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35,
          colors = brewer.pal(8, "Dark2"))
