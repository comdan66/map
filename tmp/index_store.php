
<table class='big'>
    <thead>
        <tr>
            <th width='60'>類型</th>
            <th width='110'>名稱</th>
            <th width='100'>商品照片</th>
            <th>商品說明</th>
            <th width='50'>原價</th>
            <th width='50'>售價</th>
            <th width='65'>折扣比例</th>
            <th width='65'>提供份數(日)</th>
            <th width='40'>兌換時間</th>
            <th width='50'>狀態</th>
            <th width='40'>預覽</th>
        </tr>
    </thead>
    <tbody>
<?php   if ($products) {
            foreach ($products as $product) { ?>
                <tr>
                    <td>固定商品</td>
                    <td><?php echo $product['name'];?></td>
                    <td><img src='<?php echo $product['originImage'];?>' /></td>
                    <td class='l'><?php echo $product['content'];?></td>
                    <td><?php echo $product['originPrice'];?></td>
                    <td><?php echo $product['salePrice'];?></td>
                    <td><?php echo $product['discountPercent'];?></td>
                    <td><?php echo $product['quantity'];?></td>
                    <td><a data-id='<?php echo $product['productId'];?>'  data-p='0' class='glyphicon-eye-open time'></a></td>
                    <td><?php echo $product['status'] ? '上架中' : '已下架';?></td>
                    <td><a data-id='<?php echo $product['productId'];?>'  data-p='0' class='glyphicon-eye-open show'></a></td>
                </tr>
    <?php   }
            foreach ($products as $product) {
                if ($product['profit']) {
                    foreach ($product['profit'] as $profit) { ?>
                        <tr>
                            <td><?php echo $profit['type'];?></td>
                            <td><?php echo $profit['name'];?></td>
                            <td><img src='<?php echo $profit['originImage'];?>' /></td>
                            <td class='l'><?php echo $profit['content'];?></td>
                            <td><?php echo $profit['originPrice'];?></td>
                            <td><?php echo $profit['salePrice'];?></td>
                            <td><?php echo $profit['discountPercent'];?></td>
                            <td><?php echo $profit['quantity'];?></td>
                            <td><a data-id='<?php echo $product['productId'];?>'  data-p='<?php echo $profit['profitId'];?>' class='glyphicon-eye-open time'></a></td>
                            <td><?php echo $profit['status'] ? '上架中' : '已下架';?></td>
                            <td><a data-id='<?php echo $product['productId'];?>' data-p='<?php echo $profit['profitId'];?>'  class='glyphicon-eye-open show'></a></td>
                        </tr>
            <?php   }
                }
            }
        } ?>
    </tbody>
</table>


<?php
if ($products) {
    foreach ($products as $product) { ?>
        <div class='product'>
            <div class='pic'><img src='<?php echo $product['originImage'];?>' /></div>

            <div class='title'><?php echo $product['name'];?></div>
            <div class='price'>原價：<span><?php echo $product['originPrice'];?></span></div>
            <div class='desc'><?php echo $product['content'];?></div>

            <table>
                <tbody>
                    <tr>
                        <td>上架狀態：</td>
                        <td class='<?php echo $profit['status'] ? 'r' : '';?>'><?php echo $product['status'] ? '上架中' : '已下架';?></td>
                    </tr>
                    <tr>
                        <td>商品類型：</td>
                        <td>固定商品</td>
                    </tr>
                    <tr>
                        <td>商品售價：</td>
                        <td>$<?php echo $product['salePrice'];?></td>
                    </tr>
                    <tr>
                        <td>每日份數：</td>
                        <td><?php echo $product['quantity'];?></td>
                    </tr>
                </tbody>
            </table>
        </div>
<?php
    }
    foreach ($products as $product) {
        if ($product['profit']) {
            foreach ($product['profit'] as $profit) { ?>

                <div class='product'>
                    <div class='pic'><img src='<?php echo $product['originImage'];?>' /></div>

                    <div class='title'><?php echo $profit['name'];?></div>
                    <div class='price'>原價：<span><?php echo $profit['originPrice'];?></span></div>
                    <div class='desc'><?php echo $profit['content'];?></div>

                    <table>
                        <tbody>
                            <tr>
                                <td>上架狀態：</td>
                                <td class='<?php echo $profit['status'] ? 'r' : '';?>'><?php echo $profit['status'] ? '上架中' : '已下架';?></td>
                            </tr>
                            <tr>
                                <td>商品類型：</td>
                                <td>買斷商品</td>
                            </tr>
                            <tr>
                                <td>商品售價：</td>
                                <td>$<?php echo $profit['salePrice'];?></td>
                            </tr>
                            <tr>
                                <td>每日份數：</td>
                                <td><?php echo $profit['quantity'];?></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
<?php
            }
        }
    }
} ?>
