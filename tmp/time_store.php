
<table id='time_table'>
  <tbody>
    <tr>
      <td colspan='2'>商品名稱</td>
    </tr>
    <tr>
      <td>例外日期</td>
      <td><?php echo implode (', ', $range);?></td>
    </tr>
    <tr>
      <td>兌換時間</td>
      <td>
  <?php if ($weeks) { ?>
          <table>
            <thead>
              <tr>
          <?php foreach ($weeks[0] as $day => $time) { ?>
                  <th><?php echo $day;?></th>
          <?php } ?>
              </tr>
            </thead>
            <tbody>
        
        <?php foreach ($weeks as $week) { ?>
                <tr>
            <?php foreach ($week as $day => $time) { ?>
                    <td><?php echo $time;?></td>
            <?php }?>
                </tr>
        <?php } ?>
            </tbody>
          </table>
  <?php } else {
          echo "-";
        } ?>
      </td>
    </tr>
  </tbody>
</table>