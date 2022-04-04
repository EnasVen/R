## Background ##
手機遊戲常常可以見到"轉蛋"這個機制，基本上就是消費一定數量的有償石來換取抽獎次數。  
例如:指定PU池內特定大獎發生率提高。(PU指的是英文Pick Up的意思)  
假設一個手遊大獎機率為`p=0.7%`，那麼我們每一次進行抽卡，到底要怎麼知道自己抽的結果是非洲還是歐洲呢?  
  
## Define Random Variable ##
所以我們定義隨機變數X代表抽到第一張大獎(PU卡)所需要的抽數。  
根據遊戲設定，假設n抽保底(guaranteed)，也就是最多n抽我們就能拿到大獎。  
那麼所需抽數就可以歸納出兩種情境：  
`1. 保底才抽到`
`2. 保底前抽到`  

## Computation ##
根據第1種情況，我們的抽數期望值會是 : <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}n*(1-p)^{n-1}*1" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}n*(1-p)^{n-1}*p" />  
而根據第2種情況，不失一般性假設第k抽中了，那麼抽數期望值會是 : <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}k*p*(1-p)^{k-1}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}k*p*(1-p)^{k-1}" />  
  
由於k是浮動的，我們需要把各種k值都考慮進來，因此要做summation的動作 : <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}\sum_{k=1}^{n-1}k*p*(1-p)^{k-1}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}\sum_{k=1}^{n-1}k*p*(1-p)^{k-1}" />  
這個數列是有規律的增加，因此我們可以根據以下方式計算出級數和 :  
令<img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}S=\sum_{k=1}^{n-1}k*(1-p)^{k-1}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}S=\sum_{k=1}^{n-1}k*(1-p)^{k-1}" />，也就是  <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}S&space;=&space;1*(1-p)^{0}&plus;2*(1-p)^{1}&plus;...&plus;(n-1)*(1-p)^{n-2}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}S = 1*(1-p)^{0}+2*(1-p)^{1}+...+(n-1)*(1-p)^{n-2}" />  
  
我們把S乘以(1-p)會得到 : <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}(1-p)S&space;=&space;1*(1-p)^{1}&plus;2*(1-p)^{2}&plus;...&plus;(n-1)*(1-p)^{n-1}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}(1-p)*S = 1*(1-p)^{1}+2*(1-p)^{2}+...+(n-1)*(1-p)^{n-1}" />  
  
將這兩個相減，也就是 <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}S&space;-&space;(1-p)S" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}S - (1-p)S" />  
我們會得到 : <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}1&plus;(1-p)&plus;(1-p)^{2}&plus;...&plus;(1-p)^{n-2}-(n-1)(1-p)^{n-1}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}1+(1-p)+(1-p)^{2}+...+(1-p)^{n-2}-(n-1)(1-p)^{n-1}" />  
前面的部分是等比數列，我們可以很輕易地得到級數和為 <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}\frac{1-(1-p)^{n-1}}{1-(1-p)}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}\frac{1-(1-p)^{n-1}}{1-(1-p)}" />  
  
因此這個結果會是 <img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}S-(1-p)S&space;=&space;pS&space;=&space;\frac{1-(1-p)^{n-1}}{1-(1-p)}-(n-1)(1-p)^{n-1}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}S-(1-p)S = pS = \frac{1-(1-p)^{n-1}}{1-(1-p)}-(n-1)(1-p)^{n-1}" />  
  
OK，2種情況都討論完畢後，我們可以得到抽卡數期望值為 :  
<img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}\frac{1-(1-p)^{n-1}}{1-(1-p)}-(n-1)(1-p)^{n-1}&plus;n(1-p)^{n-1}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}\frac{1-(1-p)^{n-1}}{1-(1-p)}-(n-1)(1-p)^{n-1}+n(1-p)^{n-1}" />  
<img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}=&space;\frac{1-(1-p)^{n-1}&plus;p(1-p)^{n-1}}{p}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}= \frac{1-(1-p)^{n-1}+p(1-p)^{n-1}}{p}" />  
<img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}=&space;\frac{1-(1-p)^{n}}{p}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}= \frac{1-(1-p)^{n}}{p}" />  
上式即為code內自訂函數的形式。
  
## Another Way #  
那麼，這麼複雜的推導是否有更簡潔的方式?  
我們知道X是一個非負的隨機變數(non-negative r.v.)  
因此根據機率論，我們會得到:    
<img src="https://latex.codecogs.com/gif.image?\inline&space;\dpi{110}\textbf{E(X)}&space;=&space;\sum_{x=1}^{n}&space;Pr(X\geq&space;x)&space;=&space;\sum_{x=1}^{n}(1-p)^{x-1}&space;=&space;\frac{1-(1-p)^{n}}{p}" title="https://latex.codecogs.com/gif.image?\inline \dpi{110}\textbf{E(X)} = \sum_{x=1}^{n} Pr(X\geq x) = \sum_{x=1}^{n}(1-p)^{x-1} = \frac{1-(1-p)^{n}}{p}" />  
得到同樣的結果! 

