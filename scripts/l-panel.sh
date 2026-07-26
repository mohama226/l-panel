github_push()
{

echo "=========================="
echo " Push L-PANEL to GitHub "
echo "=========================="


cd /opt/l-panel || exit


if ! command -v git >/dev/null 2>&1
then

echo "[!] Git not installed"

yum install git -y

fi


echo
read -p "Commit message: " msg


if [ -z "$msg" ]
then
msg="Update L-PANEL"
fi


git add .


git commit -m "$msg"


git push origin main


if [ $? -eq 0 ]
then

echo
echo "[OK] Successfully pushed to GitHub"

else

echo
echo "[ERROR] GitHub push failed"

fi


}
