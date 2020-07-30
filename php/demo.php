<?php include 'all.php';?>
<?php echo $head;?>
<title>测试用</title>
<?php echo $NavBar;?>
    <div class="php-main" <?php mainCard()?>>
        <?php
        
        for ($five=5; $five<10; $five++ ) {
            
            echo $five,'<br>';
        }
        echo '<br>',$five;
        ?>
    </div>
    <div class="php-main" <?php mainCard()?>>
    <form action="" method="post">
                    <input type="num" name="row" class="input-bar">
                    <input type="num" name="col" class="input-bar">
                    <input value="submit" type="submit" class="button"s>
                    
                </form>

                <?php
                
                
        $col = isset($_POST['col']) ? $_POST['col'] : 0;
        $row = isset($_POST['row']) ? $_POST['row'] : 0;
        echo '<table border="1px" cellspacing="0px" cellpadding="10">';
            $i=0;
             do {
                echo '<tr>';                
                $c=0;
            
                do{
                    echo '<td>'.($i*$col+$c).'</td>';
                    $c++;
                }while($c<$col);
                
                echo '</tr>';
                $i++;
                }while ($i<$row);

            echo '</table>';
        ?>
    </div>

    <div class="php-main" <?php mainCard()?>>
        <?php
             $num = 10;
             function demo1(&$num){
                 return $num += 10;
             }
             echo $num;
             echo demo1($num);
             echo $num;
             echo '<br>';
             function demo2($n,$m,$k){
                 echo '<pre>';
                 print_r(func_get_args());
                 echo '</pre>';
                 
             }
             demo2 ('html','css','php');
        ?>
    </div>

    <div class="php-main" <?php mainCard()?>>
        <?php
        function add($n,$m){
            return '$n+$m='.($n+$m);
        }
        function sub($n,$m){
            return '$n-$m='.($n-$m);
        }
        function mult($n,$m){
            return '$n*$m='.($n*$m);
        }
        function div($n,$m){
            return '$n/$m='.($n/$m);
        }


        $funcName = 'add';
        //echo $funcName(10,5); //==add(10,5);
        echo '<br>call_user_func_array(可变函数名称，参数列表数组)<br>';
        echo call_user_func_array($funcName,[20,5]);
        echo '<hr>';


        function demomo($funcName, $a=0, $b=0){
            return call_user_func_array($funcName,[$a,$b]);
        }
        echo demomo('div', 30, 50); 

        ?>

        <?php
        class demo3{
            static function func1($site,$lang){
                return '我在'.$site.'学习'.$lang.'编程';
            }
            public function func2($site,$lang){
                return '我在'.$site.'学习'.$lang.'编程';
            }

        }
        echo call_user_func_array(['demo3','func1'],['php','php']);
        echo '<hr>';
        echo call_user_func_array([(new demo3),'func2'],['php','js']);
        ?>
    </div>

    <div class="php-main" <?php mainCard()?>>
        <?php
        //匿名函数
        $demo4 = function ($pig){
            return '一giao我里'.$pig;
        };
        echo $demo4('giaogiao');
        echo '<hr>';
        
        function display($do){
            $page = "我丢，这么帅气？<br>";
            $site = function($name) use($page){
                return $page.'天天赤猪头肉<br>'.$name;
            };
            return $site($do);
        }
        echo display('肯定帅气啦');

        ?>
    </div>
    <div class="php-main" <?php mainCard()?>>
        <?php
        ?>
    </div>
    <div class="php-main" <?php mainCard()?>>
        <?php
        ?>
    </div>
    <div class="php-main" <?php mainCard()?>>
        <?php
        ?>
    </div>


</body>
</html>