# Instruction Formats
## Format 0 (fmt = "00"): Branch Prediction & SETHI
<table>
  <thead>
    <tr>
      <th>31</th>
      <th>30</th>
      <th>29</th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>14</th>
      <th>13</th>
      <th>12</th>
      <th>  </th>
      <th>10</th>
      <th>9</th>
      <th> </th>
      <th> </th>
      <th> </th>
      <th>5</th>
      <th>4</th>
      <th>3</th>
      <th>2</th>
      <th> </th>
      <th>0</th>
    </tr>
    <tr>
      <td align="center" colspan="2">fmt</td>
      <td align="center" colspan="20">set23hi</td>
      <td align="center" colspan="5">rd</td>
      <td align="center" colspan="2">op2</td>
      <td align="center" colspan="3">set23lo</td>
    </tr>
    <tr>
      <td align="center" colspan="2">fmt</td>
      <td align="center" colspan="16">disp19hi</td>
      <td>p</td>
      <td align="center" colspan="3">cond</td>
      <td align="center" colspan="5">rs3</td>
      <td align="center" colspan="2">op2</td>
      <td align="center" colspan="3">disp19lo</td>
    </tr>
  </thead>
</table>

## Format 1 (fmt = "01"): CALL
<table>
    <tr>
      <th>31</th>
      <th>30</th>
      <th>29</th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>0</th>
    </tr>
    <tr>
      <td align="center" colspan="2">fmt</td>
      <td align="center" colspan="30">disp30</td>
    </tr>
</table>
## Format 2 (fmt = "10"): Arithmetic Instruction
<table>
    <tr>
      <th>31</th>
      <th>30</th>
      <th>29</th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>25</th>
      <th>24</th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>19</th>
      <th>18</th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>14</th>
      <th>13</th>
      <th>12</th>
      <th>  </th>
      <th>10</th>
      <th>9</th>
      <th> </th>
      <th> </th>
      <th> </th>
      <th>5</th>
      <th>4</th>
      <th> </th>
      <th> </th>
      <th> </th>
      <th>0</th>
    </tr>
    <tr>
      <td align="center" colspan="2">fmt</td>
      <td align="center" colspan="5">rd</td>
      <td align="center" colspan="6">op3</td>
      <td align="center" colspan="5">rs1</td>
      <td align="center" colspan="1">i=0</td>
      <td align="center" colspan="3">cond</td>
      <td align="center" colspan="5">rs3</td>
      <td align="center" colspan="5">rs2</td>
    </tr>
    <tr>
      <td align="center" colspan="2">fmt</td>
      <td align="center" colspan="5">rd</td>
      <td align="center" colspan="6">op3</td>
      <td align="center" colspan="5">rs1</td>
      <td align="center" colspan="1">i=1</td>
      <td align="center" colspan="13">simm13</td>
    </tr>
</table>
## Format 3 (fmt = "11"): Load/Store Instruction
<table>
    <tr>
      <th>31</th>
      <th>30</th>
      <th>29</th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>25</th>
      <th>24</th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>19</th>
      <th>18</th>
      <th>  </th>
      <th>  </th>
      <th>  </th>
      <th>14</th>
      <th>13</th>
      <th>12</th>
      <th>  </th>
      <th>10</th>
      <th>9</th>
      <th> </th>
      <th> </th>
      <th> </th>
      <th>5</th>
      <th>4</th>
      <th> </th>
      <th> </th>
      <th> </th>
      <th>0</th>
    </tr>
    <tr>
      <td align="center" colspan="2">fmt</td>
      <td align="center" colspan="5">rd</td>
      <td align="center" colspan="6">op3</td>
      <td align="center" colspan="5">rs1</td>
      <td align="center" colspan="1">i=0</td>
      <td align="center" colspan="8">unused</td>
      <td align="center" colspan="5">rs2</td>
    </tr>
    <tr>
      <td align="center" colspan="2">fmt</td>
      <td align="center" colspan="5">rd</td>
      <td align="center" colspan="6">op3</td>
      <td align="center" colspan="5">rs1</td>
      <td align="center" colspan="1">i=1</td>
      <td align="center" colspan="13">simm13</td>
    </tr>
</table>
