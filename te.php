<?php include 'all.php';?>
<?php echo $head;?>
<title>测试用</title>
<?php echo $NavBar;?>
      <div class="php-main">
        <?php
                    echo "<hr color=\"#555\">";//分割线
            $UserInfDemo = ['name'=>'王富贵','sex'=>'男','age'=> 60];//创建数组
                echo "当前已登陆用户名: ".$_COOKIE['userName'];//输出数组
                    echo "<hr color=\"#555\">";
                echo "年龄: " ,$UserInfDemo['age'];
                    echo "<hr color=\"#555\">";
                echo "性别: ",$UserInfDemo['sex'];
                    echo "<hr color=\"#999\" size=\"5px\">";
                //熟悉的场景再现了...
        ?>
        <div style="margin-top:10;"> &nbsp</div>
        <form action="te.php?action=login" method="post">
            <input class="input-bar" type="text" name="name" id="name"/>
            <div style="margin-top:10;"> &nbsp</div>
            <input class="input-bar" type="text" name="pwd" id="pwd"/>
            <input class="button" type="submit" value="Cookie"/>
        </form>
            <div class="print">
            <?php
            if ($_GET['action']=='login') {
                if ($_POST['name']=='DemoUser' && $_POST['pwd']=='DemoPasswd'){
                    setcookie('userName',$_POST['name'],time()+3600*24);
                    setcookie('passWord',$_POST['pwd'],time()+3600*24);
                    echo '<span>cookie创建成功</span>';
                    echo '<br><span>cookie1: '.$_COOKIE['userName'],'</span>';
                    echo '<br><span>cookie2:',$_COOKIE['passWord'],'</span>';

                }else{
                    echo '<span>密码或用户名错误</span>';
                    setcookie('userName',null,time()+300);
                }
            }elseif ($_GET['action']=='logout'){
                setcookie('name','',time()+400);
            }
            ?>
            </div>
      </div>
    
      <div class="php-main">
          <?php 
              class Teessstt {
                  public $name = "王富贵";
                  public $sex = "男";
                  public $age = 60;
                  public function information(){
                      return'姓名: '.$this->name;
                  }
              }              
              $info = new Teessstt;
              $info -> jiujiujiu = function() {
                   return '啊脑袋';};
              echo $info -> name;
              echo "<hr color=\"#555\">";
              echo $info -> sex;
              echo "<hr color=\"#555\">";
              print_r ("<p>以下是用function输出</p><hr color=\"#555\">");
              echo $info -> information();
              echo "<hr color=\"#555\">";
              echo call_user_func($info->jiujiujiu);
              echo "<hr color=\"#555\">";
          ?>
        </div>
        
        <div class="php-main">
            <?php
              print_r ((object)['s','Demo','Test']);
              print_r ((object)'啾啾啾');
              print_r ((object)null); 
            ?>
        </div>
        
        <div class="php-main">
              <?php
                  $site = 'PHP';
                  echo $site;
                  echo '<hr color="#555">';
                  echo $GLOBALS['site'];
                  echo '<pre>';
                  print_r ($_SERVER['HTTP_USER_AGENT']);
                  echo '</pre>';
              ?>
        </div>
        -
        <div class="php-main">
          <?php
                session_start();
                echo session_id();
                $_SESSION['userID'] = 'Peter';
                $_SESSION['userAgent'] = $_SERVER['HTTP_USER_AGENT'];
                echo "<hr color=\"#555\">";
                echo $_SESSION['userID'];
                //unset($_SESSION['userID']);
                //session_destroy();                
          ?>
        </div>
        
        <div class="php-main">
        <form action="te.php" method="post">
        <p>输入一个数字：</p>
        <input class="input-bar" type="number" name="num">
        <input class="button" type="submit" value="上传">
        </form>

        <?php
        if (isset($_POST['num'])) {

            if ($_POST['num'] = null) {
                echo '空';
            }
            elseif ($_POST['num'] % 2 == 0) {
                echo '这是个偶数';
            }
            else {
                echo '这是个奇数';
            }}
        else {
            echo '当前为空';
        }
        ?>
        </div>
        
        <div class="php-main">
        <form action="te.php" method="post">
            <datalist id="ppx">
                <option value="皮小妹">
                <option value="王富贵">
                <option value="小黑屋">
            </datalist>
            <lable for="ppx">皮皮虾我们走</lable>
            <input type="text" name="ppx" valus="提交">

            </form>
        <?php
            switch ($_POST['ppx']){
                case '皮小妹':
                    echo '皮大脸';
                break;
                case '王富贵':
                    echo '天文地理啥都会，一到取名王富贵';
                break;
                case '小黑屋':
                    echo '封号！';
                break;
                default:
                echo '皮这一下很开心！';
                break;
            }
        ?>
        </div>
        <div class="php-main">
        <form action="" method="post">
            <input type="num" name="row" class="input-bar">
            <input type="num" name="col" class="input-bar">
            <input value="submit" type="submit" class="button"s>
            
        </form>
        <?php
        
        
        $col = isset($_POST['col']) ? $_POST['col'] : 0;
        $row = isset($_POST['row']) ? $_POST['row'] : 0;
        echo '<table border="1px" cellspacing="0px" cellpadding="10">';
            for($i=0; $i<$row; $i++) {
                echo '<tr>';
                for($c=0; $c<$col; $c++){
                    echo '<td>'.($i*$row+$c).'</td>';
                    
                }
                echo '</tr>';
            }
        echo '</table>';
            
        ?>
        </div>

     </body>
     </html>