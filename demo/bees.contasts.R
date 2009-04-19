# Bees data:
# contrasts to resolve trtime into treat, time, treat:time

cont<-matrix(scan(zz<-textConnection("
   10 -1 -1 -1 -1 -1  -1 -1 -1 -1 -1      # '0-treat'  
    0  1  1  1  1  1  -1 -1 -1 -1 -1      # 'treat'
    0 -2 -1  0  1  2  -2 -1  0  1  2      # 'time.1'   
    0  2 -1 -2 -1  2   2 -1 -2 -1  2      # 'time.2'   
    0 -1  2  0 -2  1  -1  2  0 -2  1      # 'time.3'   
    0  1 -4  6 -4  1   1 -4  6 -4  1      # 'time.4'   
"), comment.char="#"),11)
close(zz)

cnames <- c( '0-treat', 'treat', 'time.1', 'time.2', 'time.3', 'time.4')  

 
# generate interaction contrasts for treat:time
for (t in 3:6) {
	 cont <- cbind(cont, cont[,2]*cont[,t])
	 cnames <-c(cnames, paste("treat", cnames[t],sep=":"))
}
colnames(cont)<-cnames
rownames(cont)<- levels(Bees$trtime)
cont

contrasts(Bees$trtime) <-cont

# TODO: show tests of linear hypotheses using these contrasts
