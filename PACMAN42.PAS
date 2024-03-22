program pacman;
uses games,graph,crt;
type mp = array [1..31,1..28] of byte;
ghost = record
a,b,m,s,t:byte;
a1,b1:shortint;
end;
var
tb :mp;
f: file of mp;
i,j,lvl,lv:byte;
ti:word;
img:array[1..12] of pointer;
pac,poz: array[1..2] of byte;
pacm: byte;
go: array[1..4] of ghost;
scor:longint;
a1,b1:shortint;
sc:string[6];
pi,mo,s1:boolean;
a:word;
b:real;
label 1;
procedure vsync;
assembler;
asm
Mov dx,3DAh
@L2:    {asteapta inceputul: ....0... -> 00000000, doar ca 16 biti}
In al,dx
And al,08h
Jz @L2
@L1:    {asteapta sfarsitul: ....1... -> 00001000 -> 00000000}
In al,dx
And al,08h
xor al,08h
Jz @L1
end;
procedure regsw(x,y,x1,y1:word);
var i,j:word;
a,b: ^byte;
begin
a:=ptr($a000,x+y*350       );
b:=ptr($a000,x+y*350+224000);
for i:=y to y1 do
for j:=x to x1 do begin
a^:=a^ xor b^;
b^:=a^ xor b^;
a^:=a^ xor b^;
end;
end;
procedure IG;
var
DR,DM:integer;
begin
dr:=vga;
dm:=vgamed;
initgraph(dr,dm,' ');
setrgbpalette(2,63,31,0);
setrgbpalette(3,63,20,20);
setrgbpalette(4,63,63,63);
{setrgbpalette(5,63,20,63);
setrgbpalette(6,63,63,63);
setrgbpalette(7,63,63,63);
setrgbpalette(8,63,63,63);  }
end;
procedure gm(a: byte);
var gom:byte; d:word;
begin
if ((go[a].m=1) or (go[a].m=3)) and (go[a].a1=0) or ((go[a].m=2) or (go[a].m=4)) and (go[a].b1=0)
then begin
d:=32000;
if (tb[go[a].b,go[a].a-1] < 5) then if (go[a].m <> 3) then if (sqr(go[a].b-poz[2])+sqr(go[a].a-poz[1]-1) < d)
then begin gom:=1; d:=sqr(go[a].b-poz[2])+sqr(go[a].a-poz[1]-1)  end;
if (tb[go[a].b+1,go[a].a] < 5) then if (sqr(go[1].b-poz[2]+1)+sqr(go[a].a-poz[1]) < d) then if (go[a].m <> 4)
then begin gom:=2; d:=sqr(go[a].b-poz[2]+1)+sqr(go[a].a-poz[1]) end;
if (tb[go[a].b,go[a].a+1] < 5) then if (sqr(go[a].b-poz[2])+sqr(go[a].a-poz[1]+1) < d) then if (go[a].m <> 1)
then begin gom:=3; d:=sqr(go[a].b-poz[2])+sqr(go[a].a-poz[1]+1) end;
if (tb[go[a].b-1,go[a].a] < 3) then if (sqr(go[a].b-poz[2]-1)+sqr(go[a].a-poz[1]) < d) then if (go[a].m <> 2)
then gom:=4;
go[a].m:=gom;
end;
end;

begin
assign(f,'map.mp');
reset(f);
read(f,tb);
initnewkeyint;
initnewtimint;
ig;
a:=440;
b:=1.05;
setcolor(14);
line(4,1,7,1);
line(3,2,8,2);
line(2,3,9,3);
line(2,4,9,4);
line(3,5,10,5);
line(4,9,7,9);
line(3,8,8,8);
line(2,7,9,7);
line(2,6,9,6);
for i := 1 to 12 do getmem(img[i],81);
getimage(2,1,10,9,img[1]^);
setcolor(0);
line(1,4,3,4); line(1,5,5,5); line(1,6,3,6);
getimage(2,1,10,9,img[2]^);
clearviewport;
setcolor(14);
line(2,3,2,6);
line(3,2,3,7);
line(4,1,4,8);
line(5,1,5,8);
line(6,1,6,7);
line(10,3,10,6);
line(9,2,9,7);
line(8,1,8,8);
line(7,1,7,8);
getimage(2,1,10,9,img[3]^);
setcolor(0);
line(5,7,5,8); line(6,5,6,9); line(7,7,7,8);
getimage(2,1,10,9,img[4]^);
clearviewport;
setcolor(14);
line(7,1,5,1);
line(8,2,4,2);
line(9,3,3,3);
line(9,4,3,4);
line(2,5,8,5);
line(7,9,5,9);
line(8,8,4,8);
line(9,7,3,7);
line(9,6,3,6);
getimage(2,1,10,9,img[5]^);
setcolor(0);
line(9,4,8,4); line(10,5,6,5); line(9,6,8,6);
getimage(2,1,10,9,img[6]^);
clearviewport;
setcolor(14);
line(2,3,2,6);
line(3,2,3,7);
line(4,1,4,8);
line(5,1,5,8);
line(6,2,6,9);
line(10,3,10,6);
line(9,2,9,7);
line(8,1,8,8);
line(7,1,7,8);
getimage(2,1,10,9,img[7]^);
setcolor(0);
line(5,1,5,2); line(6,4,6,1); line(7,1,7,2);
getimage(2,1,10,9,img[8]^);

setfillstyle(1,12); bar(12,3,20,9); setcolor(12); line(13,2,19,2); line(14,1,18,1);
setcolor(0); line(13,9,15,9); line(17,9,19,9);
setcolor(4); circle(14,4,1); putpixel(14,4,0); circle(18,4,1); putpixel(18,4,0);
getimage(12,1,20,9,img[9]^);
setfillstyle(1,13); bar(12,3,20,9); setcolor(13); line(13,2,19,2); line(14,1,18,1);
setcolor(0); line(13,9,15,9); line(17,9,19,9);
setcolor(4); circle(14,4,1); putpixel(14,4,0); circle(18,4,1); putpixel(18,4,0);
getimage(12,1,20,9,img[10]^);
setfillstyle(1,11); bar(12,3,20,9); setcolor(11); line(13,2,19,2); line(14,1,18,1);
setcolor(0); line(13,9,15,9); line(17,9,19,9);
setcolor(4); circle(14,4,1); putpixel(14,4,0); circle(18,4,1); putpixel(18,4,0);
getimage(12,1,20,9,img[11]^);
setfillstyle(1,2); bar(12,3,20,9); setcolor(2); line(13,2,19,2); line(14,1,18,1);
setcolor(0); line(13,9,15,9); line(17,9,19,9);
setcolor(4); circle(14,4,1); putpixel(14,4,0); circle(18,4,1); putpixel(18,4,0);
getimage(12,1,20,9,img[12]^);
lv:=4       ;
1:  lv:=lv-1;    ti:=0;
for i:=1 to 4 do go[i].m:=4;
pac[1]:= 15;
pac[2]:= 24;
go[1].a:=15;
go[1].b:=12;
go[2].a:=15;
go[2].b:=12;
go[2].b1:=2;
go[3].a:=15;
go[3].b:=12;
go[3].b1:=3;
go[4].a:=15;
go[4].b:=12;
go[4].b1:=4;
tickwait(9);
for i:=1 to 31 do
begin
    for j:=1 to 28 do
    begin
    case tb[i,j] of
    0,3:;
    1,4:putpixel(j*10+5,i*10+5,15);
    2:begin setcolor(15);circle(j*10+5,i*10+5,1); putpixel(j*10+5,i*10+5,15) end;
   { 3:;}
    else
    begin
    setfillstyle(1,1);
    bar(j*10,i*10,(1+j)*10,(1+i)*10)  end;
    end;
    end;
end;
pacm:=1;
repeat
regsw(1,1,20,20);
setcolor(0); str(ti,sc); outtextxy(50,0,sc);
if ti < 65000 then ti:=ti+1 else ti:=0;
setcolor(15); str(ti,sc); outtextxy(50,0,sc);
if pi then putimage(pac[1]*10+1+a1,pac[2]*10+1+b1,img[pacm*2-1]^,0)
      else putimage(pac[1]*10+1+a1,pac[2]*10+1+b1,img[pacm*2  ]^,0);
putimage(go[1].a*10+1+go[1].a1,go[1].b*10+1+go[1].b1,img[9 ]^,1);
{if tb[go[1].a,go[1].b]=1 then putpixel(go[1].a*10+5,go[1].b*10+5,12);  }
putimage(go[2].a*10+1+go[2].a1,go[2].b*10+1+go[2].b1,img[10]^,1);
{if tb[go[2].a,go[2].b]=1 then putpixel(go[2].a*10+5,go[2].b*10+5,13); }
putimage(go[3].a*10+1+go[3].a1,go[3].b*10+1+go[3].b1,img[11]^,1);
{if tb[go[3].a,go[3].b]=1 then putpixel(go[3].a*10+5,go[3].b*10+5,11);}
putimage(go[4].a*10+1+go[4].a1,go[4].b*10+1+go[4].b1,img[12]^,1);
{if tb[go[4].a,go[4].b]=1 then putpixel(go[4].a*10+5,go[4].b*10+5,2);}
{for i:=1 to 31 do
for j:=1 to 28 do
if tb[i,j]=1 then  if getpixel(j*10+5,i*10+5) = 0 then putpixel(j*10+5,i*10+5,15);}
if s1 then sound(140)
      else sound(a);
a:=trunc(a*b);
if a > 900+scor   then b:=0.95;
if a < 400+scor*2 then b:=1.05;
vsync;
if s1 then sound(140)
      else sound(a);
s1:=false;
a:=trunc(a*b);
if a > 900+scor   then b:=0.95;
if a < 400+scor*2 then b:=1.05;
vsync;
if pi then putimage(pac[1]*10+1+a1,pac[2]*10+1+b1,img[pacm*2-1]^,1)
      else putimage(pac[1]*10+1+a1,pac[2]*10+1+b1,img[pacm*2  ]^,1);
if pacm <> 1 then if keydown[leftscan]  then if tb[pac[2],pac[1]-1] < 5 then begin pacm:=1; a1:=0; b1:=0 end;
if pacm <> 2 then if keydown[downscan]  then if tb[pac[2]+1,pac[1]] < 5 then begin pacm:=2; a1:=0; b1:=0 end;
if pacm <> 3 then if keydown[rightscan] then if tb[pac[2],pac[1]+1] < 5 then begin pacm:=3; a1:=0; b1:=0 end;
if pacm <> 4 then if keydown[upscan]    then if tb[pac[2]-1,pac[1]] < 5 then begin pacm:=4; a1:=0; b1:=0 end;
if pacm = 1 then if tb[pac[2],pac[1]-1] < 5 then begin pi:=not pi;
if a1-1 < -5 then begin pac[1]:=pac[1]-1; a1:=+4; end else a1:=a1-1; end;
if pacm = 2 then if tb[pac[2]+1,pac[1]] < 5 then begin pi:=not pi;
if b1+1 > 5 then begin pac[2]:=pac[2]+1; b1:=-4; end else b1:=b1+1; end;
if pacm = 3 then if tb[pac[2],pac[1]+1] < 5 then begin pi:=not pi;
if a1+1 > 5 then begin pac[1]:=pac[1]+1; a1:=-4; end else a1:=a1+1; end;
if pacm = 4 then if tb[pac[2]-1,pac[1]] < 5 then begin pi:=not pi;
if b1-1 < -5 then begin pac[2]:=pac[2]-1; b1:=+4; end else b1:=b1-1; end;
if pac[1]=1 then pac[1]:=27;
if pac[1]=28 then pac[1]:=2;
case ti of
129,486:  for i:=1 to 4 do begin go[i].s:=0; go[i].t:=0; go[i].m:=5-go[i].m;end;
972,1680: for i:=1 to 4 do begin go[i].s:=0; go[i].t:=36;go[i].m:=5-go[i].m;end;
end;
if go[1].s = 1 then begin poz[1]:=pac[1]; poz[2]:=pac[2];  end
else begin poz[1]:=25; poz[2]:=0; go[1].t:=go[1].t+1; if go[1].t = 129 then go[1].s:= 1 end;
gm(1);
if go[1].s = 1 then
case pacm of
1: begin poz[1]:=pac[1] - 4; poz[2]:=pac[2]; end;
2: begin poz[1]:=pac[1]; poz[2]:=pac[2] + 4; end;
3: begin poz[1]:=pac[1] + 4; poz[2]:=pac[2]; end;
4: begin poz[1]:=pac[1] - 4; poz[2]:=pac[2] - 4; end;
else begin poz[1]:=3; poz[2]:=0; end;
end else begin poz[1]:=3; poz[2]:=0; end;
gm(2);
if go[1].s = 1 then begin
case pacm of
1: begin poz[1]:=pac[1] - 2; poz[2]:=pac[2]; end;
2: begin poz[1]:=pac[1]; poz[2]:=pac[2] + 2; end;
3: begin poz[1]:=pac[1] + 2; poz[2]:=pac[2]; end;
4: begin poz[1]:=pac[1] - 2; poz[2]:=pac[2] - 2; end;
else begin poz[1]:=31; poz[2]:=28; end;
end;
poz[1]:=poz[1]-abs(go[1].a-poz[1]);
poz[2]:=poz[2]-abs(go[1].b-poz[2]);  end
else begin poz[1]:=31; poz[2]:=28; end;
gm(3);
if go[1].s=0 then if sqr(pac[1]-go[4].a) + sqr(pac[2]-go[4].b) > 64 then
begin poz[1]:=pac[1]; poz[2]:=pac[2]; end else begin poz[1]:=0; poz[2]:=28; end
else begin poz[1]:=0; poz[2]:=28; end;
gm(4);
putimage(go[1].a*10+1+go[1].a1,go[1].b*10+1+go[1].b1,img[9 ]^,1);
putimage(go[2].a*10+1+go[2].a1,go[2].b*10+1+go[2].b1,img[10]^,1);
putimage(go[3].a*10+1+go[3].a1,go[3].b*10+1+go[3].b1,img[11]^,1);
putimage(go[4].a*10+1+go[4].a1,go[4].b*10+1+go[4].b1,img[12]^,1);
for i:=1 to 4 do if go[i].a=1 then go[i].a:=27;
for i:=1 to 4 do if go[i].a=28 then go[i].a:=2;
for i:=1 to 4 do case go[i].m of
1 : if go[i].a1-1<-5 then begin go[i].a:=go[i].a-1; go[i].a1:={go[i].a1}+4 end else go[i].a1:=go[i].a1-1;
2 : if go[i].b1+1>5  then begin go[i].b:=go[i].b+1; go[i].b1:={go[i].b1}-4 end else go[i].b1:=go[i].b1+1;
3 : if go[i].a1+1>5  then begin go[i].a:=go[i].a+1; go[i].a1:={go[i].a1}-4 end else go[i].a1:=go[i].a1+1;
4 : if go[i].b1-1<-5 then begin go[i].b:=go[i].b-1; go[i].b1:={go[i].b1}+4 end else go[i].b1:=go[i].b1-1;
end;
setcolor(0); str(scor,sc); outtextxy(0,0,sc);
if tb[pac[2],pac[1]]=1 then begin tb[pac[2],pac[1]]:=0; scor:=scor+1; s1:=true; end;
if tb[pac[2],pac[1]]=4 then begin tb[pac[2],pac[1]]:=3; scor:=scor+1; s1:=true; end;
if tb[pac[2],pac[1]]=2 then begin for i:=1 to 4 do go[i].m:=5-go[i].m; tb[pac[2],pac[1]]:=0  end;
setcolor(15); str(scor,sc); outtextxy(0,0,sc);
for i:=1 to 4 do if (pac[1]=go[i].a) and (pac[2]= go[i].b) then goto 1;
until (scor = 240) or (lv = 0) or
  keydown[scanof('c')];
  setoldkeyint;
  nosound;
end.