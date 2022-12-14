# 1717709 이동현 빅데이터 시각화 기말고사 

# 문제 1.1
dim(testData)

# 문제 1.2
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(ggcorrplot)

# 문제 2.1
testData$size = ifelse(testData$pop21 >= 500000, "대", ifelse(testData$pop21 >= 200000,"중","소"))
testData

# 문제 2.2 (1)
mean(testData$index)
median(testData$index)
min(testData$index)
max(testData$index)

quantile(testData$index, probs = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9))

# 문제 2.2 (2)
mean(testData$financeRate21, na.rm = T)
median(testData$financeRate21, na.rm = T)
min(testData$financeRate21, na.rm = T)
max(testData$financeRate21, na.rm = T)

# 문제 2.3
ggplot(testData, aes(size, index))+
  geom_boxplot()+
  labs(title = "1717709 이동현 boxplot", x= "인구규모", y = "사회안전지수")

# 문제 3.1

seoul = testData %>% 
  filter(si == "서울") %>% 
  select(gu,index) %>% 
  arrange(index)
  
seoul

# 문제 3.2

v1 <- seoul$gu
v2 <- seoul$index
barplot(v2, main = "1717709 이동현", xlab = "서울시 행정구역(구)명", ylab = "사회안전지수", 
        col = brewer.pal(n=11, name = "RdBu"))


# 문제 4.1
data <- subset(testData, select = c(index, company21, financeRate21, EconomicRate, laborRate, pop21, popMove21)) 
data <- round(cor(data, use = "na.or.complete"),3)
data

# 문제 4.2

data1 <- subset(testData, select = c(index, company21, financeRate21, EconomicRate, laborRate))
data1 <- round(cor(data1, use = "na.or.complete"),3)
data1

ggcorrplot(data1, hc.order = T,
           type = "upper",
           lab = T,
           lab_size = 3,
           method = "circle",
           colors = c("tomato2","white","springgreen3"),
           title = "1717709 이동현",
           ggtheme = theme_bw())

# 문제 4.3
cor.test(testData$financeRate21, testData$popMove21)
cor.test(testData$financeRate21, testData$popMove21, method = "spearman")
cor.test(testData$financeRate21, testData$popMove21, method = "kendall")

# 문제 5.1

pop <- ddply(testData, .(si,size), summarise, i = mean(index, na.rm = T),
             f = mean(financeRate21, na.rm = T), p = sum(popMove21 ,na.rm = T),
             e = mean(EconomicRate ,na.rm = T))

pop
dim(pop)

# 문제 5.2

busan <- pop %>% filter(si == "부산")
busan

# 문제 5.3

big <- testData %>% filter(size == "대")
big

g <- ggplot(big, aes(x=index, y=financeRate21)) + 
  geom_point(aes(col=si, size=EconomicRate)) +
  labs(title="1717709 이동현", x = "사회안전지수", y="재정자립도")

g

pop

big1 <- pop %>% filter(size == "대")
big1

g1 <- ggplot(big1, aes(x=i, y=f)) + 
  geom_point(aes(col=si, size=e)) +
  labs(title="1717709 이동현", x = "사회안전지수", y="재정자립도")
g1

# 문제 7.1
library(stringr)

reviews <- c("통쾌한 액션 영화입니다",
             "이런 통렬한 사이다같은 맛은 맛별로 시리즈물 계속 나와야 함 ",
             "ㄹㅇ 오랜만에 깔깔거리면서 봄ㅋㅋ ",
             "추천순보고 재미없는 줄 알았네 ㅋㅋㅋ 엄청 재밌는데, 액션은 평범하지만 어벤져스 까지의 내용전개에 진짜 꼭 필요한 내용, 꿀잼",
             "이렇게나 건조하고 차가운 블랙코미디. 이 자는 정말 나쁜 놈이며 그간 저질러온 숱한 악행들은 벌해야 하지만, 이놈도 결국 벌거벗기면 한낱 개인일 뿐이다.",
             "이런걸 보는 사람들이 우리나라에 같이 살고있다는게 참 한심스럽다 " ,
             "우상화 ",
             "전작에 비해 아쉬움 ㅁㅁ",
             "믿고 보는 범죄의 도시! 계속된 재미",
             "저도 범죄의 도시 정주행중 ㅋㅋ 그냥 1편이나 2편이나 비슷하게 재미 있는 것 같음",
             "범죄의 도시 정주행중!! 마동석 멋져",
             "확실히 2편은 뭔가 약해..쩝",
             "1편보단 못하다... 처음이랑 끝에 밖에 액션신도 없고.. 기대보단 좀... 매력이 없다",
             "악당 리얼 최민식 닮음 나만 느낌???",
             "전작에 비해 아쉽지만 여전히 어벤져서 라인업 중 가장 세련된 시리즈"
)
titles <- c("범죄도시2", "범죄도시2", "탑건: 매버릭", "범죄도시2", "탑건: 매버릭", "탑건: 매버릭", "범죄도시2", "범죄도시2", "탑건: 매버릭", "탑건: 매버릭", "범죄도시2", "범죄도시2", "탑건: 매버릭", "탑건: 매버릭")



## 2. 사전 만들기
pos.words <- c("멋져", "재미", "믿고", "정주행중", "세련된", "꿀잼", "통쾌한", "깔깔거리면서", "사이다", "세련된")
neg.words <- c("기대보단", "못하다", "아쉬움", "약해..쩝", "허무했고", "우상화", "건조하고", "한심스럽다", "기대보단")

table(titles)

# 문제 7.2

index = which(titles=="범죄도시2")
index

str_count(reviews[1], .words)

# 문제 7.3

predict <- NULL

for(i in index){
  pos.cnt <- str_count(reviews[i], pos.words)
  p<-sum(pos.cnt)
  neg.cnt <- str_count(reviews[i], neg.words)
  n <- sum(neg.cnt)
  
  if(p>n){
    predict <- c(predict,1)
  } else if(p<n){
    predict <- c(predict,-1)
  } else{
  predict <- c(predict,0)
  }
}

# 문제 7.4

predict
p <- length(predict[predict==1])
n <- length(predict[predict==-1])

table(predict)

polarity <- (p-n)/(p+n)
polarity

# 문제 7.5

pie(table(predict), col = c("red","yellow","blue"))


