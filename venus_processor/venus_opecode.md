# 金星プロセッサ命令表
from: <https://www.ddna.cs.tsukuba.ac.jp/lecture/lsi_design/index.html>

|番号|優先順位|分類|命令|mnemonic|opecode(7bit)|immf(1bit)|rd(4bit)|rs(4bit)|imm(16bit)|operation|備考|
|---|---|---|---|---|---|---|---|---|---|---|---|
|0|◎|Integer|add|ADDx|000_0000|immf|rd|rs|#16|rd = rd + (rs \| #16)|即値は符号拡張する|
|1|◎||sub|SUBx|000_0001|immf|rd|rs|#16|rd = rd - (rs \| #16)|即値は符号拡張する|
|2|○||mul|MULx|000_0010|immf|rd|rs|#16|rd = rd mul (rs \| #16)|即値は符号拡張する|
|3|△||div|DIVx|000_0011|immf|rd|rs|#16|rd = rd div (rs \| #16)|即値は符号拡張する|
|4|◎||compar|CMPx|000_0100|immf|rd|rs|#16|rd - (rs \| #16)|即値は符号拡張する, rd は変化しない|
|5|○||absolute|ABSx|000_0101|immf|rd|rs|#16|rd = abs(rs \| #16)|即値は符号拡張する|
|6|△||add with carry|ADCx|000_0110|immf|rd|rs|#16|rd = rd + (rs \| #16) + carry|即値は符号拡張する|
|7|△||sub widh carry|SBCx|000_0111|immf|rd|rs|#16|rd = rd - (rs \| #16) - carry|即値は符号拡張する|
|8|◎|Shift|shift left|SHLx|000_1000|immf|rd|rs|#16|rd = rd << (rs \| #16)|rs, #16 共有効なのは下位5bit, 即値は符号無し|
|9|◎||shift right|SHRx|000_1001|immf|rd|rs|#16|rd = rd >> (rs \| #16)|rs, #16 共有効なのは下位5bit, 即値は符号無し|
|10|○||alithmetic shift|ASHx|000_1010|immf|rd|rs|#16|rd = rd >>> (rs \| #16)|rs, #16 共有効なのは下位5bit, 即値は符号無し|
|11||||||||||||
|12|△||rotate left|ROLx|000_1100|immf|rd|rs|#16|"rd = rotate_left(rd\| (rs \| #16))"|rs, #16 共有効なのは下位5bit, 即値は符号無し|
|13|△||rotate right|RORx|000_1101|immf|rd|rs|#16|"rd = rotate_right(rd\| (rs \| #16))"|rs, #16 共有効なのは下位5bit, 即値は符号無し|
|14||||||||||||
|15||||||||||||
|16|◎|論理演算|and|AND|001_0000|0|rd|rs|-|rd = rd AND rs||
|17|◎||or|OR|001_0001|0|rd|rs|-|rd = rd OR rs||
|18|◎||not|NOT|001_0010|0|rd|rs|-|rd = NOT rs||
|19|○||exclucive or|XOR|001_0011|0|rd|rs|-|rd = XOR rs||
|20||||||||||||
|21||||||||||||
|22|○||set low|SETL|001_0110|1|rd|-|#16|"rd = {rd[31:16], #16}"||
|23|○||set hi|SETH|001_0111|1|rd|-|#16|"rd = {#16, rd[15:0]}"||
|24|◎|Load/Store|load|LD|001_1000|1|rd|rs|#16|rd = [rs + #16]|即値は符号付きとする|
|25|◎||store|ST|001_1001|1|rs|rd|#16|[rd + #16}] = rs|即値は符号付きとする|
|26||||||||||||
|27||||||||||||
|28|◎|分岐|jump|J|001_1100|immf|cc|rs|#16|if (cc) PC = PC + (rs \| #16)|即値は符号付きとする|
|29|◎||jump absolute|JA|001_1101|immf|cc|rs|#16|if (cc) PC = (rs \| #16)|即値は符号付きとする|
|30|◎|その他|no oparation|NOP|001_1110|0|-|-|-||何もしない|
|31|△||halt|HLT|001_1111|0|-|-|-||パイプラインの動作を止める|

## 備考
|acronym|name|meaning|
|---|---|---|
|immf|immediate flag|immf==0 rs を使用する。 Immf==1 即値を使用する|
|rd|desitination register|オペランドの一つとして使用し，結果を格納するレジスタ|
|rs|source register|オペランドの一つとして使用するレジスタ|
|cc|condition code|条件コード|
|#16|immediate|16 bit の即値|

|index|cc|name|meaning|
|---|---|---|---|
|0|000|always|常に条件分岐成立|
|1|001|zero|ゼロの時に条件分岐成立|
|2|010|positive|正の時(MSB == 0) 条件分岐成立|
|3|011|negative|負の時(MSB == 1) 条件分岐成立|
|4|100|carry|キャリーが生じているとき条件分岐成立|
|5|101|overflow|オーバーフローの時条件分岐成立|
|6|110|-||
|7|111|-||