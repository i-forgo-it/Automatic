# Automatic
Automatic is a simple bash script made to automate usefull tools for recon and content discovery. It looks for redirects,LFi,sli,xss,nuclei templates and some recon tools and you can also set up a rate limit and a user agent to use when scanning

# how it works 
You first answer the questions to run the tools ![image](https://github.com/i-forgo-it/Automatic/assets/163911891/34891b27-e0e2-4279-a90f-02c847a2dd5a)

Then it goes through subfinder => it updates the resolvers to go to puredns => httpx then go or waybackurls or both then it looks for patterns so you can use them to feed them to the tools and then it runs the tools if you said yes, and  then it goes through nuclei for the parameters and for the site in general and to end everything it takes a nice screenshot of everysubdomain. You can also add nuclei templates to the scan at the start.

in the end you have your files ready ![image](https://github.com/i-forgo-it/Automatic/assets/163911891/87d699e7-70d5-43c7-87da-be7b005cf8b2)

# Small note 
I wanted to make a script that automates some of my recon and after finishing why not share it on github :). Keep in mind this is a simple script and I am not a god so sorry if you get erros but you should not (i hope).
I will certainly be looking to improve this script in the future so if you guys want to improve it or have suggestions or you get some erros don't hesitate !!

# how to use
First you need to download all the tools that are used in the script nuclei,subfinder,httpx,gf,Haylxon,puredns,waybackurls or gau,(sqlmap,dalfox,corsy.py)those between brackets are optional.
Note, if you have an error it may because of the tools that are not updated or properly set up for example gf with the patterns and stuff.

git clone the script

Then you need to change the path in the script of the hxn to your right browser and where is your httpx on your machine and the path to corsy.py if you have installed it.

I also used a template for nuclei by https://github.com/projectdiscovery/nuclei-templates/issues/9253, if you don't download it and point the path to it, it won't be able to scan for redirects.





