
<?php include 'all.php';?>
<?php echo $head;?>
<title>测试用</title>

<?php echo $NavBar;?>

      <div class="php-main">
        <?php
                    echo "<hr color=\"#555\">";//分割线
            $UserInfDemo = ['name'=>'王富贵','sex'=>'男','age'=> 60];//创建数组
                echo "姓名: ",$UserInfDemo['name'];//输出数组
                    echo "<hr color=\"#555\">";
                echo "年龄: " ,$UserInfDemo['age'];
                    echo "<hr color=\"#555\">";
                echo "性别: ",$UserInfDemo['sex'];
                    echo "<hr color=\"#999\" size=\"5px\">";
                //熟悉的场景再现了...
        ?>
        <div style="margin:10px;"></div>
        <form action="te.php" method="post"><!--表单输入-->
            <input class="input-bar" type="text" name="name"/>
            <input class="button" type="submit" value="上传"/>
        </form>

        <!--表单输出-->
        <div class="print"><?php echo "输入的内容是: <br/>",$_POST['name'];?></div>

      </div>
      <?php echo $footer;?>
