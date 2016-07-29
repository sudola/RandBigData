
#set the system environment variables
spark_path <-strsplit(system("brew info apache-spark",intern=T)[4],' ')[[1]][1] # Get your spark path
Sys.setenv(SPARK_HOME = file.path(spark_path,"libexec"))
.libPaths(c(file.path(spark_path,"libexec", "R", "lib"), .libPaths())) # Navigate to SparkR folder

#load the Sparkr library
library(SparkR)
Sys.setenv('SPARKR_SUBMIT_ARGS'='"--packages" "com.databricks:spark-csv_2.11:1.4.0" "sparkr-shell"')

# Create a spark context and a SQL context
sparkEnvir <- list(
  #spark.yarn.queue = '...', 
  spark.executor.memory = '2g',
  spark.executor.instances = '20',
  spark.yarn.driver.memoryOverhead = '1024', 
  spark.yarn.executor.memoryOverhead = '1024', 
  spark.driver.extraJavaOptions='-XX:MaxPermSize=1024m'#512m' 
)
sc <- sparkR.init( appName = 'test R', master ="local[*]", sparkEnvir = sparkEnvir)#, sparkPackages="com.databricks:spark-csv_2.11:1.4.0")
sqlContext <- sparkRSQL.init(sc)

#sparkR.stop() - stop the spark context
#SparkR::: - RDD/map/reduce/...

#create a sparkR DataFrame
DF <- createDataFrame(sqlContext, faithful)
head(DF)

DF1 <- select(DF, "eruptions")

## read csv file, important databricks-spark-csv jar
df <- read.df(sqlContext, "./data/cars.csv", source = "com.databricks.spark.csv", inferSchema = "true")
head(df)

# examples from sparkR distribution: SPARK_HOME/examples/src/main/r
path <- file.path(Sys.getenv("SPARK_HOME"), "examples/src/main/resources/people.json")
peopleDF <- read.json(sqlContext, path)
printSchema(peopleDF)

########################################################
path <- file.path("./data/categories.csv") # z pliku z nazwy nagłówka trzeba usunąć ca_id_11
system.time(
  categories <- read.df(sqlContext, path = path, source = "com.databricks.spark.csv", header="true", inferSchema = "true")
)
count(categories)
#remove bad cateogries with Null fields in table etc.#no distinction between NA and NULL
categories %>% filter(isNotNull(categories$ca_id_12)) %>% filter(categories$ca_level!=1) %>% filter(categories$ca_name_1!="Not Found") -> categories
count(categories)
head(categories)
printSchema(categories)
str(categories)
describe(categories) #w wyniku są inne typy danych niż w printSchema :-(

#change column in DataFrame - as.numeric
#categories$ca_level <- categories$ca_level *1

#average and max depth of category tree
collect(summarize(categories,avg(categories$ca_level),max(categories$ca_level),min(categories$ca_level)))

summary(categories)

#count number of leaf subcategories in main categories (main means 1st level, "ca_name_1")
df <- count(groupBy(categories, "ca_name_1"))
count(df)

#number of subcategories in main categories
collect(arrange(df,desc(df$count)))
library(magrittr)
df %>% arrange(desc(df$count)) %>% collect

#depth statistics in allegro category tree
df <- agg(groupBy(categories, "ca_name_1"), n(categories$id_category), min(categories$ca_level), max(categories$ca_level), avg(categories$ca_level))
df %>%  arrange(desc(df$`max(ca_level)`)) %>% collect

#number of 3rd level categories
categories %>% groupBy("ca_name_1","ca_name_3") %>% agg(count=n(categories$id_category)) %>% arrange("ca_name_1","count",decreasing=TRUE) -> df
count(df)
df.tmp <- collect(df)
view(df.tmp)

###############################################################

applicationId<-SparkR:::callJMethod(SparkR:::callJMethod(sc, "sc"), "applicationId")
applicationId

#wordcount, letter count #################################################
#pyspark: wordcounts = words.map(lambda s: (s, 1)).reduceByKey(lambda a, b : a + b).collect()
words <- SparkR:::parallelize(sc,c("hello", "world", "goodbye", "hello", "again"))

pairs <- SparkR:::map(words,function(word){ list(word,1L)} )
letters <- SparkR:::flatMap(words,function(word){ if(length(word)>0) strsplit(word,NULL)[[1]]  else list()})
pairs2 <- SparkR:::map(letters,function(word){ list(word,1L)} )

SparkR:::take(pairs2,10)

res<-SparkR:::reduceByKey(pairs2,"+",2L)
res2<-SparkR::collect(res)
res2

library(magrittr)
SparkR:::parallelize(sc,c("hello", "world", "goodbye", "hello", "again")) %>% SparkR:::map(function(word){ list(word,1L)}) %>%
   SparkR:::reduceByKey("+",2L) %>% SparkR::collect() -> results
results
# TODO: wordcount dla pliku tekstowego
# jak to zrobić w kolumnie dataframe??
# wordcount w nazwach ofert

#####################
#word count dal pliku tesktowego ########
#wordCounts = textFile.flatMap(lambda line: line.split()).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a+b).collect()
lines <- read.text(sqlContext=sqlContext, path="./data/tekst_kwiat.txt")
showDF(limit(lines, 10))

library(stringi)

lines2 <- SparkR:::textFile(sc, "./data/tekst_kwiat.txt")
SparkR::take(lines2,10)

lines2 <- SparkR:::map(lines,
                      function(line) {
                        str <- stringi::stri_replace_all_regex(line, "[,.;-]", "")
                        stringr::str_to_lower(str)
                      })
SparkR::take(lines2,10)
words <- SparkR:::flatMap(lines2,
                      function(line) {
                         if(length(line)>0) strsplit(line, " ")[[1]]
                         else list()
                      })
SparkR::take(words,10)
counts  <- SparkR:::map(words,
                        function(word) {
                           list(word,1)
                        })
SparkR::take(counts,10)
counts2 <- SparkR:::reduceByKey(counts,"+",2L)
SparkR::collect((counts2))

counts2 <- SparkR:::countByKey(counts)
counts2

SparkR:::saveAsTextFile(counts2,"./data/tekst_kwiat_results.txt")
output <- collect(counts2)
for (wordcount in output) {
  cat(wordcount[[1]], ": ", wordcount[[2]], "\n")
}

SparkR:::map(lines, nchar) %>% SparkR:::reduce("+") # char count

#################################
path <- file.path("./data/offers_Dom_Zdrowie.csv")
offers <- read.df(sqlContext, path = path, source = "com.databricks.spark.csv", header="true", inferSchema = "true")
showDF(offers)

offers_names <- SparkR::select(offers,c("name","leaf_category"))
offers_names$name <- SparkR::regexp_replace(offers_names$name,"_"," ")
offers_names$leaf_category_id <- SparkR::regexp_extract(offers_names$leaf_category,"([0-9]+)__",1)
showDF(offers_names)
offers_names_a <- SparkR::filter(offers_names, offers_names$leaf_category_id=="126202")
showDF(offers_names_a)
offers_local <- SparkR::collect(SparkR::select(offers_names_a,"name"))

library(tm)
# build a corpus, which is a collection of text documents
# VectorSource specifies that the source is character vectors.
myCorpus <- Corpus(VectorSource(offers_local$name))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeNumbers)
TDM <- TermDocumentMatrix(myCorpus)
inspect(TDM[1:10,1:10])
findFreqTerms(TDM, lowfreq=1000)
findAssocs(TDM, 'donica', 0.10)

library(wordcloud)
m <- as.matrix(TDM)
# calculate the frequency of words
v <- sort(rowSums(m), decreasing=TRUE)
myNames <- names(v)
d <- data.frame(word=myNames, freq=v)
wordcloud(d$word, d$freq, min.freq=500)

tdm2 <- as.matrix(TDM)
# calculate the frequency of words
frequency <- rowSums(tdm2)
frequency <- sort(frequency, decreasing=TRUE)
head(frequency,20)
words <- names(frequency)
wordcloud(words[1:1000], frequency[1:1000])

tdms <- removeSparseTerms(TDM, .95)
dim(tdms)
inspect(tdms[1:10,1:20])

library(cluster)   
d <- dist(tdms, method="euclidian")   
fit <- hclust(d=d, method="ward.D")   
fit   
plot(fit, hang=-1)   

plot.new()
plot(fit, hang=-1)
groups <- cutree(fit, k=5)   # "k=" defines the number of clusters you are using   
rect.hclust(fit, k=5, border="red") # draw dendogram with red borders around the 5 clusters   

library(fpc)   
d <- dist(tdms, method="euclidian")   
kfit <- kmeans(d, 2)   
clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)   
#########################################
pal <- brewer.pal(9,"BuGn")
pal <- pal[-(1:4)]
c<-layout(matrix(c(1, 2), nrow=2), heights=c(1, 6))
layout.show(c)
par(mar=rep(0, 4)) 

  pdf(file, family='NimbusSan',encoding="CP1250.enc", paper = "a4")            
  
    plot.new()
    text(0.5, 0.5, "TYTUŁ",col=pal,font=2)
  #  wordcloud(words,frequency,min.freq=1000,colors=pal)
          
  dev.off()
###############################

  # Stop the SparkContext now
  sparkR.stop()
  