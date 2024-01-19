IFNDEF HEAD_INC
HEAD_INC equ 1

; 导入库...
include include/comctl32.inc
include include/comdlg32.inc
include include/fpu.inc
include include/gdi32.inc
include include/gdiplus.inc
include include/kernel32.inc
include include/msvcrt.inc
include include/shell32.inc
include include/shlwapi.inc
include include/user32.inc
include include/windows.inc
include include/winmm.inc

includelib lib/comctl32.lib
includelib lib/comdlg32.lib
includelib lib/fpu.lib
includelib lib/gdi32.lib
includelib lib/gdiplus.lib
includelib lib/kernel32.lib
includelib lib/msvcrt.lib
includelib lib/shell32.lib
includelib lib/shlwapi.lib
includelib lib/user32.lib
includelib lib/winmm.lib

;-------------------------------------------------------------------------------
;; 函数
WinMain PROTO  :DWORD, :DWORD, :DWORD, :DWORD
OnCreate PROTO

Picture PROTO
DrawTitle PROTO
DrawChooseMode PROTO

DrawMan PROTO  : DWORD
DrawBall PROTO
DrawPoint PROTO
DrawOneFrame PROTO
RefreshStatus PROTO
Paint PROTO

BallOutBound PROTO
BallHitGround PROTO
BallHitNet PROTO
BallStop PROTO
CheckBallStatus PROTO

BallDegree PROTO
BallMove PROTO
Rebound PROTO  : SDWORD
BallThreePoint PROTO
RefreshBall PROTO  : SDWORD, : SDWORD, : SDWORD, : SDWORD

CheckHitBall PROTO
ManHitBall PROTO  : SDWORD, : SDWORD, : SDWORD, : SDWORD,: SDWORD

ManMove PROTO
GuanGong PROTO
QinQiong PROTO

KeyUp PROTO  : WPARAM
KeyDown PROTO  : WPARAM
LButtonUp PROTO  : WPARAM, : LPARAM

InitGame PROTO
WndProc PROTO  : HWND, : UINT, : WPARAM, : LPARAM

PlayAudio PROTO  : DWORD, : DWORD
;-------------------------------------------------------------------------------
.const
wWidth       equ 900  ; 窗口大小
wHeight      equ 600
midWidth     equ 450  ; 球网位置
netHeight    equ 475  ; 球网高
groundHeight equ 575  ; 地面位置
ballHeight   equ 520  ; 发球时球的高度
ballLimit    equ 10	  ; 球出界
manLimit     equ 80	  ; 角色出界
ballPos      equ 40	  ; 发球位置
RacketX      equ 90   ; 拍长度
RacketY      equ 80

bSize equ 80
lInterval equ 6
IDC_START equ 1		  ; 开始按钮
idTimer dd 1		  ; 定时器


.data
szClassName db 'MASM32',        0
szAppName   db 'asm_game',      0
bInterval db lInterval dup(0)

; 图片
; 界面图片
titleAddr  db 'img/title.png',  0
modeAddr   db 'img/mode.png' ,  0
backAddr   db 'img/back.png' ,  0
; 球和角色
ballAddr   db 'img/ball.png' ,  0
body1Addr  db 'img/body1.png',  0
body2Addr  db 'img/body2.png',  0

; 手
hand01Addr db 'img/frame/frame01.png', 0
hand02Addr db 'img/frame/frame02.png', 0
hand03Addr db 'img/frame/frame03.png', 0
hand04Addr db 'img/frame/frame04.png', 0
hand05Addr db 'img/frame/frame05.png', 0
hand06Addr db 'img/frame/frame06.png', 0
hand07Addr db 'img/frame/frame07.png', 0
hand08Addr db 'img/frame/frame08.png', 0
hand09Addr db 'img/frame/frame09.png', 0
hand10Addr db 'img/frame/frame10.png', 0
hand11Addr db 'img/frame/frame11.png', 0
hand12Addr db 'img/frame/frame12.png', 0
hand13Addr db 'img/frame/frame13.png', 0
hand14Addr db 'img/frame/frame14.png', 0
hand15Addr db 'img/frame/frame15.png', 0

; 分数
point0Addr db 'img/0.png',      0
point1Addr db 'img/1.png',      0
point2Addr db 'img/2.png',      0
point3Addr db 'img/3.png',      0
point4Addr db 'img/4.png',      0
point5Addr db 'img/5.png',      0

; 音频
audioPlayID dd 0
audioPlay   db "MPEGVideo",     0
bgmFile	    db "bgm.wav",       0

clock DWORD 0

Ball STRUCT
	mx  SDWORD 0
	my  SDWORD 0
	mvx REAL4  0.
	mvy REAL4  0.
	max REAL4  0.
	may REAL4  0.
	hitTime BYTE 0  ; 打击地面次数
	cantHit BYTE 0	; 是否可以击打
    deg TBYTE 0
Ball ENDS
bad Ball <ballPos, ballHeight, 20., -20., 0., 0., 0, 0, 0>  ; 初始化在发球位置

; 三点定位
threePoint POINT <0, 0>, <0, 0>, <0, 0>
; 20√2 ≈ 28
bx1 SDWORD -20
bx2 SDWORD -20
bx3 SDWORD 20
by1 SDWORD -20
by2 SDWORD 20
by3 SDWORD -20
bxp SDWORD 0
byp SDWORD 0

Man STRUCT
	player DWORD  0	  ; 1 / 2
	point  DWORD  0
	mx     SDWORD 0	  ; 中心点的位置
	my     SDWORD 0
	mvx    REAL4  0.
	mvy    REAL4  0.
	move   SDWORD 0	  ; 0 / 1 / -1
	hit    DWORD  0
	frame1 DWORD  0	 ; 挥拍图片加载顺序
	frame2 DWORD  0
Man ENDS
man1 Man <1, 0, manLimit,              netHeight, 0., 0., 0, 0, 0, 0>
man2 Man <2, 0, wWidth - manLimit-200, netHeight, 0., 0., 0, 0, 0, 0 >

ballPreX SDWORD ballPos
ballPreY SDWORD ballHeight
man1preX SDWORD manLimit
man1preY SDWORD netHeight
man2preX SDWORD wWidth - manLimit - 200
man2preY SDWORD netHeight

; 游戏参数
zero     REAL4 0.
ab       REAL4 0.4	 ; 羽毛球下落加速度
af       REAL4 0.05	 ; 阻力系数
ag       REAL4 0.5	 ; 人下落加速度
velocity SDWORD 20   ; 球的初速度
manvp    REAL4 6.    ; 左右移动速度+
manvn    REAL4 -6.   ; -
manjmpv  REAL4 12.   ; 起跳速度
tmvx SDWORD ?
tmvy SDWORD ?
hitGroundTimer DWORD 10

; 方向键置零
kw		BYTE 0
ka		BYTE 0
ks		BYTE 0
kd		BYTE 0
kup		BYTE 0
kdown	BYTE 0
kleft	BYTE 0
kright	BYTE 0
kenter	BYTE 0

leftAuto		BYTE 1
rightAuto		BYTE 1
leftHitting	    BYTE 0
rightHitting	BYTE 0

startHit	BYTE 1	; 0: 不发球，1: 左边发球，2: 右边发球
ballPre	    BYTE 1
leftWin     db   "GuanGong Wins!", 0
rightWin    db   "QinQiong Wins!", 0
MsgCaption  db   "The End",        0

chooseMode BYTE 1
oneWin BYTE 0
drawTitle BYTE 1
drawingRule BYTE 1

gpiInput GdiplusStartupInput<1, 0, 0, 0>

picture BYTE 0

; 调库需要的参数...
.data?
titleImg  dd ?
backImg   dd ?
ballImg   dd ?
modeImg   dd ?
body1Img  dd ?
body2Img  dd ?
shadowImg dd ?
hand01Img dd ?
hand02Img dd ?
hand03Img dd ?
hand04Img dd ?
hand05Img dd ?
hand06Img dd ?
hand07Img dd ?
hand08Img dd ?
hand09Img dd ?
hand10Img dd ?
hand11Img dd ?
hand12Img dd ?
hand13Img dd ?
hand14Img dd ?
hand15Img dd ?

point0Img dd ?
point1Img dd ?
point2Img dd ?
point3Img dd ?
point4Img dd ?
point5Img dd ?

hInstance HINSTANCE ?
szCommandLine LPSTR ?
hDC  HDC  ?
hWnd HWND ?
dwTimerId1 dd  ?
token      dd  ?
mybitmap   dd  ?
oldbitmap  dd  ?
bitmaphdc  HDC ?
graphics   dd  ?
graphics2  dd  ?

ENDIF
