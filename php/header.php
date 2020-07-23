<!DOCTYPE html>

<html>
	<head>
		<meta charset="utf-8">
		<link rel="stylesheet" href="css/style.default.css" id="theme-stylesheet">
		<link rel="stylesheet" href="css/custom.css">
		<link rel="stylesheet" href="css/animate.css">
		<link rel="shortcut icon" href="img/favicon.png">
		
		<title></title>
	</head>
	<body>
<div>
    <?php
    /*
    <header class="bg-gray">
			<nav class="navbar">
				<div style="height: 50px;">
					<div class="animated fadeInDown">
					    		  <a href="index.html" target="_blank"  title="回到欢迎页" class="title-logo">Apiclo.</a>
								  <table border="0"  align="right">
								  <tr>
							      <td><a href="src.html" target="_blank" class="headmenu-btn">个人主页</a></td>
								  <td><a href="hehua.html" target="_blank" class="headmenu-btn">往期作业</a></td>
								  <td><a href="text.html" target="_blank"  class="headmenu-btn">拓展资料</a></td>
								  <td><a href="intro.html" target="_blank" class="headmenu-btn">站点介绍</a></td>
								  <td><a href="http://apiclo.vicp.io" target="_blank" class="headmenu-btn">强行凑够5个</a></td>
								  </tr>
								  </table>
					
					</div>
		
				</div>
			</nav>
		</header>
    */?>
</div>

<?php		
//变量不能以数字开始,但是数字可以夹在变量名中间和结尾
$cm = 10086;
echo "$cm"
?><br>

<?php
//8进制的取值范围最大为0-7,即0,1,2,3,4,5,6,7

$eigh =  033145;
echo $eigh,"<br>";
echo $_SERVER["HTTP_USER_AGENT"];

?><br>

<?php
//声明一个变量（拼音）为布尔
$buer = true;
//导明一个变量(英文)
$bool = false;?><br>

<?php
//声明字符串变量$zhifu

$wocao = '曾经有操蛋的爱情摆在我面前，我珍惜了。当我得到的时候才感到后悔莫及。如果非要在这段爱情前面加上一段三个字，我愿意说三个字：滚犊子';

//你可以放XAMPP指定的目录下，新建一个文件叫str.php。然后访问一下http://127.0.0.1/str.php试试。会不会显示这句话。

echo $wocao;

?><br>
<?php
//声明字符串变量$str
$str = "如果非要在滚犊子前面加上一个时间的话我愿意是马上。";

echo $str;
?><br>
<?php

$dingjie = <<<ABC
  如果
       非要在这个滚犊子
   前
       面<br/>
      加上一段
   <i>距离的话</i>
   我想说：<h1>思想有多远，你就跟我滚多远</h1>
ABC;
echo $dingjie;
?>

<?php
//声明变量$shouji
$shouji = '为了苹果手机去卖肾';
//在双引号中放$shouji 然后echo 一下是什么效果呢？
$str = "$shouji 会不会显示呢?";
//输入$str试试
echo $str;
?><br>

<?php
$php = 'php中文网';

$str = "{$php}aaaa";
//双引号遇到变量时，加大括号
echo $str;
?><br>

<?php
//声明一个字符串，记住是双引号
$string = "每天来PHP中文网\n 给梦想\t 一个机会";
echo $string;
?><br>
<?php

//要在$beizi的字符串中显示一个双引号怎么办？
$beizi = "多于绝大多数的人出生就是杯具，但是\"我们在不断的让人生变为喜剧\"";

echo $beizi;
?><br>

<?php

$legend = '猛虎';

$NoAlike = "心有'$legend',细嗅蔷薇";

echo $NoAlike;

?><br>

<?php

$shixi = '大学4年要好好学习<br />';

$buran = '不然连实习的机会都没有<br />';

$mimang = '把别人用来迷茫的时间拿到PHP中文网<br />';

$xuexi = '学习PHP<br />';

//我们可以把字符串全部拼接起来。
echo $shixi . $buran . $mimang . $xuexi;

?>
因此，刚刚的问题一的代码我们可以改为：
<?php
$php = 'PHP中文网';
//中间加了空格哟
$str = $php . 'aaaa';

echo $str;
?><br>

<?php
//定义一下中奖变量，变量的值为true,表示中奖了
$zhongjiang = true;
//由于$zhongjiang 结果为true，所以显示了：“买个房子”
//可以改为false试试执行结果，如果为false的话，不会执行echo '买个房子';

if($zhongjiang){
   echo '买个房子';
}
else{
//后续代码
echo '该干嘛干嘛';
    
}
?><br/>
<?php

$apple = null;
if(empty($apple)){
    echo '执行了真区间，凤姐，我爱你';
}else{
   echo '行了假区间，你想凤姐了';
}
?><br>
<?php
$one = 10;
$two = false;
$three = 0;
$four = 0;

$result = isset($one , $two , $three , $four);
//执行看看结果，是不是
var_dump($result);

?><br>
<?php
  //声明一个变量88.8，你可以自己多做几次实验换成其他类型看看$type输出是多少
  $float = 889999;
  $type = gettype($float);

  echo $type;

?><br>
<?php
//其实可以小写，但是不好区分，所以我们规定通常大写
define('xiaoxie',true);
echo xiaoxie,"<br>";

//常量可以在外面不加引号
define('YH','不要对未来迷茫，迷茫的时候静下心来coding');
echo YH,"<br>";

//只能用标量，我在后面用了一个数组，大家学一下就行,会报错的哟
define('BIAO',array(1,2,3));

?>

<?php 
echo PHP_OS,PHP_VERSION;
?>

<?php
$shu = 'biao';
$biao = 'wo';
$wo = 'test';
$test = 'sina';
$sina = 'zhongguo';
$zhongguo = 'china';
$china = '我爱你';
//别运行，自己去推理一下代码。也写几个可变变量玩玩吧！
echo $$$$$$$shu;
?>

       <form action="header.php" method="post">
           <input type="text" name="username" />
           <input type="password" name="pwd" />
           <input type="submit" value="提交" />
       </form>
 

	   <?php
//$_GET后面加上中括号，将username作为字符串放在中括号里面，就得到了表单里面的<input type="text" name="username" /> 的值
$u = $_POST['username'];
echo $u.'<br />';

//$_GET['pwd'] 得到表单<input type="text" name="username" /> 的值
$passwd = $_POST['pwd'];
echo $passwd.'<br />';
?><br>
<?php 
$week=date("4");
//判断星期小于6，则输出：还没到周末，继续上班.....
if ($week<"6") {
 echo "还没到周末，继续上班.....";
} 
?>
<form>
 <input type="text" name="num1">

 <select name="fh">
 <option value="jia"> + </option>
 <option value="jian"> - </option>
 <option value="c"> x </option>
 <option value="chu"> / </option>
 <option value="qy"> % </option>

 </select>

 <input type="text" name="num2">

 <input type="submit" value="运算" />


</form>

<?php

 $num1 = $_GET['num1'];
 $num2 = $_GET['num2'];
 $fh = $_GET['fh'];

 if(!is_numeric($num1) || !is_numeric($num2)){

 echo '请输入数值类型';
 }

 if($fh == 'jia'){
 echo $num1 . '+' . $num2 . '=' . ($num1+$num2);
 }

 if($fh=='jian'){
 echo $num1 . '-' . $num2 . '=' . ($num1-$num2);
 }

 if($fh=='c'){
 echo $num1 . 'x' . $num2 . '=' . ($num1*$num2);
 }
 if($fh=='chu'){
 echo $num1 . '/' . $num2 . '=' . ($num1/$num2);
 }
 if($fh=='qy'){
 echo $num1 . '%' . $num2 . '=' . ($num1%$num2);
 }

?>






	</body>
	
</html>