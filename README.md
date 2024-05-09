# Automatic
Automatic is a simple bash script made to automate usefull tools for recon and content discovery. It looks for redirects,LFi,sli,xss,nuclei templates and some recon tools and you can also set up a rate limit and a user agent to use when scanning. You can also set up a time limit so that if exceeds that time limit the nuclei scan goes to the next.

# how it works 
You first answer the questions to run the tools ![image](https://github.com/i-forgo-it/Automatic/assets/163911891/a080ce9e-864a-4ceb-9000-a1972683399a)


Then it goes through subfinder => it updates the resolvers to go to puredns => httpx then go or waybackurls or both then it looks for patterns so you can use them to feed them to the tools and then it runs the tools if you said yes, and  then it goes through nuclei for the parameters and for the site in general and to end everything it takes a nice screenshot of everysubdomain. You can also add nuclei templates to the scan at the start.

in the end you have your files ready ![image](https://github.com/i-forgo-it/Automatic/assets/163911891/c928a745-910c-4ab1-826c-df520b3bd86c)


# Small note 
I wanted to make a script that automates some of my recon and after finishing why not share it on github :). Keep in mind this is a simple script and I am not a god so sorry if you get erros but you should not (i hope).
I will certainly be looking to improve this script in the future so if you guys want to improve it or have suggestions or you get some erros don't hesitate !!

# how to use
First you need to download all the tools that are used in the script nuclei,subfinder,httpx,gf,Haylxon,puredns,waybackurls or gau,(sqlmap,dalfox,corsy.py)those between brackets are optional.
Note, if you have an error it may because of the tools that are not updated or properly set up for example gf with the patterns and stuff.

git clone the script

Then you need to change the path in the script of the hxn to your right browser and where is your httpx on your machine and the path to corsy.py if you have installed it.
like in those screenshots
![image](https://github.com/i-forgo-it/Automatic/assets/163911891/b9bcc606-8798-4c9d-b9ad-f97423909a0d)
![image](https://github.com/i-forgo-it/Automatic/assets/163911891/13909b56-f452-42a1-8cae-919e0d22d0dd)
![image](https://github.com/i-forgo-it/Automatic/assets/163911891/a87cc49c-b4d5-470e-ada2-05076a80bb86)
![image](https://github.com/i-forgo-it/Automatic/assets/163911891/0786a9a8-c590-4794-a366-2ccfca88bd85)
![image](https://github.com/i-forgo-it/Automatic/assets/163911891/f84987c6-9471-45a6-9a2b-3fad1ab3d047)
![image](https://github.com/i-forgo-it/Automatic/assets/163911891/0b4d74fe-cec4-4e77-ad9b-91e0415166b7)





!!ATENTION IF YOU USE dalfox do not forget to change the blind payload to yours otherwise i'll be getting all the bounties :).

I also used a template for nuclei by https://github.com/projectdiscovery/nuclei-templates/issues/9253, if you don't download it and point the path to it, it won't be able to scan for redirects.





