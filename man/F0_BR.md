# Branch Prediction Instructions 
## Description: 
The branch prediction instruction compares the contents of 0 and rs3, and decides whether to branch or not based on the result. Also, if the value of the prediction bit (p bit) is 1, it performs a branch in advance and then performs the comparison. If the value of the prediction bit (p bit) is 0, it performs the comparison without executing the branch. These are used to reduce pipeline hazards. The prediction bit can be assigned arbitrarily by the user.

## Assembly Language Syntax: 
```
brcond regrs3, label(address)
```

## Behavior: 
```
brcond: 
    if(p＝1) { 
        tmp ← pc + 1 
        pc  ← sign_ext(disp19hi & disp19lo & “00”) 
    } else { 
        tmp ← sign_ext(disp19hi & disp19lo & “00”) 
        pc  ← pc + 1 
    } 
    switch(cond) { 
        case 0: token ← rs3<0>＝‘0’ 
        case 1: token ← rs3＝0 
        case 2: token ← rs3＜0 
        case 3: token ← rs3≦0 
        case 4: token ← rs3<0>＝‘1’ 
        case 5: token ← rs3≠0
        case 6: token ← rs3＞0 
        case 7: token ← rs3≧0 
    } 
    if(p＝1 and token＝0 || p＝0 and token＝1) { 
        pc ← tmp 
    } 

<Trap> 
    None
```

pc: Program Counter
