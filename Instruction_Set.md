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

<table>
  <tr>
    <th colspan="2">op2</th>
    <th colspan="3">cond</th>
    <th>mnemonic</th>
    <th>instruction</th>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td align="center" colspan="3"> </td>
    <td>SETHI</td>
    <td>Set High 23 bits of rs3 Register</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>0</td></td>
    <td>0</td></td>
    <td>0</td></td>
    <td>BRLBC</td>
    <td>Branch if Register Low Bit is Clear</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>0</td></td>
    <td>0</td></td>
    <td>1</td></td>
    <td>BRZ</td>
    <td>Branch on Register Zero</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>0</td></td>
    <td>1</td></td>
    <td>0</td></td>
    <td>BRLZ</td>
    <td>Branch on Register Less Than Zero</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>0</td></td>
    <td>1</td></td>
    <td>1</td></td>
    <td>BRLEZ</td>
    <td>Branch on Register Less Than or Equal to Zero</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>1</td></td>
    <td>0</td></td>
    <td>0</td></td>
    <td>BRLBS</td>
    <td>Branch if Register Low Bit is Set</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>1</td></td>
    <td>0</td></td>
    <td>1</td></td>
    <td>BRNZ</td>
    <td>Branch on Register Not Zero</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>1</td></td>
    <td>1</td></td>
    <td>0</td></td>
    <td>BRGZ</td>
    <td>Branch on Register Greater Than Zero</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>1</td></td>
    <td>1</td></td>
    <td>1</td></td>
    <td>BRGEZ</td>
    <td>Branch on Register Greater Than or Equal to Zero</td>
  </tr>
  <tr>
    <td>1</td>
    <td>0</td>
    <td colspan="5">unused</td></td>
  </tr>
  <tr>
    <td>1</td>
    <td>1</td>
    <td colspan="5">unused</td></td>
  </tr>
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

<table>
  <tr>
    <th colspan="6">op3</th>
    <th>mnemonic</th>
    <th>instruction</th>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td>
    <td>ADD</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>1</td>
    <td>AND</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td>
    <td>OR</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>0</td><td>0</td><td>1</td><td>1</td>
    <td>XOR</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>0</td>
    <td>SUB</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>1</td>
    <td>ANDN</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>0</td><td>1</td><td>1</td><td>0</td>
    <td>ORN</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>0</td><td>1</td><td>1</td><td>1</td>
    <td>XNOR</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td>0</td>
    <td>MUL</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td>1</td>
    <td>UMULH</td>
    <td></td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>1</td><td>0</td><td>1</td><td>0</td>
    <td colspan="2">-</td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>1</td><td>0</td><td>1</td><td>1</td>
    <td colspan="2">-</td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>1</td><td>1</td><td>0</td><td>0</td>
    <td colspan="2">-</td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>1</td><td>1</td><td>0</td><td>1</td>
    <td colspan="2">-</td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>1</td><td>1</td><td>1</td><td>0</td>
    <td colspan="2">-</td>
  </tr>
  <tr>
    <td>0</td><td>0</td><td>1</td><td>1</td><td>1</td><td>1</td>
    <td colspan="2">-</td>
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
