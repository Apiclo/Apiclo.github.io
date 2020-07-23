<?php include 'all.php';?>
<?php echo $head;?>
<title>测试用</title>
<?php echo $NavBar;?>
    <div class="php-main">
        <?php
        
        for ($five=5; $five<10; $five++ ) {
            
            echo $five,'<br>';
        }
        echo '<br>',$five;
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

    <div class="php-main">
        <?php
             
        ?>
    </div>

    <div class="php-main">
        <?php
        ?>
    </div>

    <div class="php-main">
        <?php
        ?>
    </div>

    <div class="php-main">
        <?php
        ?>
    </div>


</body>
</html>