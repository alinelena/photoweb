#!/bin/bash
#### Author: (c) Alin M Elena
####Email: alin.elena@yahoo.co.uk
####www: http://titus.phy.qub.ac.uk/group/Alin/
####date: 2nd-3rd January 2007   

# Argument check
ARGS=3
E_BADARGS=65
E_BADFOLD=64
if [ $# != "$ARGS" ]
then
echo "Usage: sh `basename $0` gallery-name folder-pictures file-description"
echo "##########################################"
echo "# Info                                   #"
echo "# Usage: sh `basename $0` gallery-name folder-pictures file-description" #
echo "# file-description should contain the description of the picture you want to display #"
echo "# let us assume that we have folder-pictures=images and file-description=info.txt  #"
echo "# if in images we have 01.jpg then in info.txt we add a line #"
echo "# images/01.jpg \" Picture description\"#"
echo "# Description should be short and informative (and written in one line ) #"
echo "# for this example you will run the script as #"
echo "#  sh `basename $0` "Gallery Name" images info.txt #"
echo "# Read more in README                   #"
echo "##########################################"

exit $E_BADARGS
fi

fdescription=$3
if [ -e $fdescription ]
then
dexists=0
else
dexists=1
fi

if [ $dexists ]
then
echo "description file found"
else
echo "no description file found, no description will be provided"
fi

pfolder=$2
if [ -d $pfolder ]
then
echo "folder found, going further..."
else
echo "folder does not exists"
exit $E_BADFOLD
fi

images=0

title=$1
list=`ls -x $pfolder/*`

for i in $list
do
images=`expr $images + 1`
done

echo "$images photos found!"
k=0

for i in $list
do
k=`expr $k + 1`
filename="target"$k".html"
if [ dexists ]
then
description=`grep -i $i $fdescription | replace $i " "`
fi
next=`expr $k + 1`
prev=`expr $k - 1`
fprev="target"$prev".html"
fnext="target"$next".html"
echo " processing photo $k"


echo " <?xml version=\"1.0\" encoding=\"iso-8859-1\"?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"
\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\"> 
<html xmlns=\"http://www.w3.org/1999/xhtml\"> " >$filename
echo "<head>
 	<meta name=\"robots\" content=\"index, follow\" />  
	<meta name=\"description\" content=\"Photo Gallery\" />
	<meta name=\"language\" content=\"en\" />
	<meta http-equiv=\"Content-Type\" content=\"application/xhtml+xml; charset=iso-8859-1\" />
	<title>In pictures: $title </title>
	<link rel=\"stylesheet\" type=\"text/css\" href=\"css/style.css\" />	
</head>" >>$filename
echo "<body>
<div class=\"table2\">
  <div class=\"table-row2\">
	<div class=\"containerhf\">
		<div class=\"txt\">
		<span class=\"PicsTxt\">In pictures:</span>
		<span class=\"GalName\">$title</span>
		</div>
	</div>
    </div>" >>$filename
echo "   <div class=\"table-row2\">
	<div class=\"containerpict\">
		<img class=\"GalPict\" alt=\"image\" src=\"$i\" />
	</div>
    </div>
    <div class=\"table-row2\">
	<div class=\"PicsTxt\">Info: $description </div>
    </div>
	<div class=\"table-row2\">
	    <div class=\"containerhf\">
		<div class=\"txt\">Click below for more images</div>
	    </div>
	</div>
<div class=\"table-row2\">">>$filename


if [ "$k" -eq "1" ]
then
echo "<div class=\"container11\">
	  <span><img src=\"gifs/back_grey.gif\" alt=\"back\" /></span>
	  <span class=\"noLink\">BACK</span>
	</div>">>$filename
else
echo "<div class=\"container11\">
	  <span><img src=\"gifs/back.gif\" alt=\"back\" /></span>
	  <span class=\"txtLinks\"><a href=\"$fprev\">BACK</a></span>
	</div>">>$filename
fi

echo "<div class=\"containermedium\">">>$filename
m=0
for j in $list
do
m=`expr $m + 1`
f1="target"$m".html"
if [ $i = $j ]
then
echo "<span class=\"selectedbox\" onclick=\"location.href='$f1'\">
	  <a href=\"$f1\">$m</a></span>">>$filename
else
echo "<span class=\"unselectedbox\" onclick=\"location.href='$f1'\">
	  <a href=\"$f1\">$m</a></span>">>$filename
fi
done
echo "</div>">>$filename
if [ "$k" -eq "$images" ]
then
echo "<div class=\"container15\">
	<span class=\"noLink\">NEXT</span>
	<span><img src=\"gifs/next_grey.gif\" alt=\"next\" /></span>	  
	</div>">>$filename
else
echo " <div class=\"container15\">
	 <span class=\"txtLinks\"><a href=\"$fnext\">NEXT</a></span>
	 <span><img src=\"gifs/next.gif\" alt=\"next\" /></span>
	</div>">>$filename
fi
echo "</div> </div>
</body>
</html>">>$filename
if [ "$k" -eq "1" ]
then
cp $filename index.html
fi
done


echo "Gallery generated. To link to you can use something like"
echo "<a href=\"index.html\" onclick=\"window.open('index.html', '1155036654', 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=610,height=540,left=280,top=100'); return false;\">$title</a>"

exit 0
