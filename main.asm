.386
.model flat, stdcall
option casemap:none

include head.inc

.code
;-------------------------------------------------------------------------------
;; 程序入口
Start:
INVOKE GetModuleHandle, NULL
mov hInstance, eax
INVOKE GetCommandLine
mov szCommandLine, eax

INVOKE GdiplusStartup, OFFSET token, OFFSET gpiInput, NULL
INVOKE WinMain, hInstance, NULL, szCommandLine, SW_SHOWDEFAULT
INVOKE GdipDeleteGraphics, graphics
INVOKE GdiplusShutdown, token
INVOKE ExitProcess, eax
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;; 窗口
WinMain PROC hInst: HINSTANCE, hPrevInst: HINSTANCE, szCmdLine: LPSTR, nShowCmd: DWORD
	local msg:  MSG
	local rect: RECT
	local wndClassEx: WNDCLASSEX

    ; 窗口...
 	mov   wndClassEx.cbSize, sizeof WNDCLASSEX
	mov   wndClassEx.style, CS_HREDRAW or CS_VREDRAW
 	mov   wndClassEx.lpfnWndProc, OFFSET WndProc
	mov   wndClassEx.cbWndExtra, NULL
	mov   wndClassEx.cbClsExtra, NULL

    push  hInstance
	pop   wndClassEx.hInstance
	mov   wndClassEx.hbrBackground, COLOR_WINDOW
	mov   wndClassEx.lpszClassName, OFFSET szClassName

    INVOKE LoadIcon, NULL, IDI_WINLOGO
	mov   wndClassEx.hIcon, eax
	mov   wndClassEx.hIconSm, eax
	INVOKE LoadCursor, NULL, IDC_ARROW
	mov   wndClassEx.hCursor, eax
	INVOKE RegisterClassEx, ADDR wndClassEx

    ; 窗口的上下左右位置
	mov rect.top, 0
	mov rect.left, 0
	mov rect.bottom, wHeight
	mov rect.right, wWidth
    INVOKE AdjustWindowRectEx, ADDR rect, WS_CAPTION or WS_SYSMENU or WS_BORDER, FALSE, 0

    mov ecx, rect.right
	sub ecx, rect.left
	mov edx, rect.bottom
	sub edx, rect.top

    ; 窗口居中
    ; (把ecx, edx存下来!!!)
	push ecx
	push edx
	INVOKE GetSystemMetrics, SM_CYSCREEN  ; 获取窗口高度
	pop edx
	pop ecx
	sub eax, edx
	push edx
	mov edx, 0
	mov esi, 2
	div esi
	pop edx
	mov ebx, eax  ; ebx存储y
	push ecx
	push edx
	push ebx

	INVOKE GetSystemMetrics, SM_CXSCREEN
	pop ebx
	pop edx
	pop ecx
	sub eax, ecx
	push edx
	mov edx, 0
	mov esi, 2
	div esi       ; eax存储x
	pop edx
	INVOKE CreateWindowEx, NULL, ADDR szClassName, ADDR szAppName, WS_CAPTION or WS_SYSMENU or WS_BORDER , eax, ebx, ecx, edx , NULL, NULL, hInst, NULL
	mov hWnd, eax

	INVOKE ShowWindow, hWnd, nShowCmd
	INVOKE UpdateWindow, hWnd

    ; 消息循环
	.while TRUE
		INVOKE GetMessage, ADDR msg, NULL, 0, 0
		.break .if (!eax)
		INVOKE TranslateMessage, ADDR msg
		INVOKE DispatchMessage, ADDR msg
	.endw
	mov     eax, msg.wParam
	ret
WinMain ENDP

OnCreate PROC
local init:INITCOMMONCONTROLSEX
.data?
	hEdtInterval HWND ?
.code
	mov init.dwSize, sizeof INITCOMMONCONTROLSEX
	mov init.dwICC, ICC_COOL_CLASSES
	INVOKE InitCommonControlsEx, ADDR init

    ; 播放BGM
	INVOKE PlayAudio, hWnd, ADDR bgmFile
	ret
OnCreate ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;; 绘制
; 获取图片
Picture PROC
.data
	address db 60 dup(?)
.code
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET titleAddr,  -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR titleImg
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET modeAddr,   -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR modeImg
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET backAddr,   -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR backImg

	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET ballAddr,   -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR ballImg
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET body1Addr,  -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR body1Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET body2Addr,  -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR body2Img

	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand01Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand01Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand02Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand02Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand03Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand03Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand04Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand04Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand05Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand05Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand06Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand06Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand07Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand07Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand08Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand08Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand09Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand09Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand10Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand10Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand11Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand11Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand12Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand12Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand13Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand13Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand14Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand14Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET hand15Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR hand15Img

	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET point0Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR point0Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET point1Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR point1Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET point2Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR point2Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET point3Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR point3Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET point4Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR point4Img
	INVOKE MultiByteToWideChar, CP_ACP, NULL, OFFSET point5Addr, -1, OFFSET address, sizeof address
	INVOKE GdipLoadImageFromFile, OFFSET address, ADDR point5Img
	ret
Picture ENDP

; 调用GDI绘制标题页, 选择游戏模式
DrawTitle PROC
	INVOKE GdipDrawImageRectI, graphics, titleImg, 0, 0, 900, 600
	ret
DrawTitle ENDP
DrawChooseMode PROC
	INVOKE GdipDrawImageRectI, graphics, modeImg, 0, 0, 900, 600
	ret
DrawChooseMode ENDP

; 绘制角色
DrawMan PROC uses eax ebx ecx edx player: DWORD
	; 左侧角色
	.if player == 1
		mov eax, man1.mx
		sub eax, 150
		mov ebx, man1.my
		sub ebx, 80
		; 绘制左侧角色
		INVOKE GdipDrawImageRectI, graphics2, body1Img, eax, ebx, 224, 192 ; img

		mov eax, man1.mx
		sub eax, 150
		mov ebx, man1.my
		sub ebx, 150
		.if man1.frame1 > 16 || startHit == 1  ; 击球
			add ebx, 50
			sub eax, 5
		.endif
		.if startHit == 1
			INVOKE GdipDrawImageRectI, graphics2, hand11Img, eax, ebx, 224, 192
		.elseif man1.frame1 == 0
			INVOKE GdipDrawImageRectI, graphics2, hand01Img, eax, ebx, 224, 192
		.elseif man1.frame1 == 1
			INVOKE GdipDrawImageRectI, graphics2, hand02Img, eax, ebx, 224, 192
			dec man1.frame1
			mov man1.hit, 0  ; 已经击球
		.elseif man1.frame1 == 2
			INVOKE GdipDrawImageRectI, graphics2, hand03Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 3
			INVOKE GdipDrawImageRectI, graphics2, hand04Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif	man1.frame1 == 4
			INVOKE GdipDrawImageRectI, graphics2, hand05Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 5
			INVOKE GdipDrawImageRectI, graphics2, hand06Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 6
			INVOKE GdipDrawImageRectI, graphics2, hand07Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 7
			INVOKE GdipDrawImageRectI, graphics2, hand08Img, eax, ebx, 224, 192
			dec man1.frame1

		.elseif man1.frame1 == 21
			INVOKE GdipDrawImageRectI, graphics2, hand09Img, eax, ebx, 224, 192
			mov man1.frame1, 7
			mov man1.hit, 0  ; 已经击球
		.elseif man1.frame1 == 22
			INVOKE GdipDrawImageRectI, graphics2, hand10Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 23
			INVOKE GdipDrawImageRectI, graphics2, hand11Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 24
			INVOKE GdipDrawImageRectI, graphics2, hand12Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 25
			INVOKE GdipDrawImageRectI, graphics2, hand13Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 26
			INVOKE GdipDrawImageRectI, graphics2, hand14Img, eax, ebx, 224, 192
			dec man1.frame1
		.elseif man1.frame1 == 27
			INVOKE GdipDrawImageRectI, graphics2, hand15Img, eax, ebx, 224, 192
			dec man1.frame1
		.endif
	; 右侧角色
	.else
		mov eax, man2.mx
		add eax, 150
		mov ebx, man2.my
		sub ebx, 80
		INVOKE GdipDrawImageRectI, graphics2, body2Img, eax, ebx, -224, 192
		mov eax, man2.mx
		add eax, 150
		mov ebx, man2.my
		sub ebx, 160
		.if man2.frame1 >16 || startHit == 2
			add ebx, 50
			add eax, 5
		.endif
		.if startHit == 2
			INVOKE GdipDrawImageRectI, graphics2, hand11Img, eax, ebx, -224, 192
		.elseif man2.frame1 == 0
			INVOKE GdipDrawImageRectI, graphics2, hand01Img, eax, ebx, -224, 192
		.elseif man2.frame1 == 1
			INVOKE GdipDrawImageRectI, graphics2, hand02Img, eax, ebx, -224, 192
			dec man2.frame1
			mov man2.hit, 0
		.elseif man2.frame1 == 2
			INVOKE GdipDrawImageRectI, graphics2, hand03Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 3
			INVOKE GdipDrawImageRectI, graphics2, hand04Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 4
			INVOKE GdipDrawImageRectI, graphics2, hand05Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 5
			INVOKE GdipDrawImageRectI, graphics2, hand06Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 6
			INVOKE GdipDrawImageRectI, graphics2, hand07Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 7
			INVOKE GdipDrawImageRectI, graphics2, hand08Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 21
			INVOKE GdipDrawImageRectI, graphics2, hand09Img, eax, ebx, -224, 192
			mov man2.frame1, 7
			mov man2.hit, 0
		.elseif man2.frame1 == 22
			INVOKE GdipDrawImageRectI, graphics2, hand10Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 23
			INVOKE GdipDrawImageRectI, graphics2, hand11Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 24
			INVOKE GdipDrawImageRectI, graphics2, hand12Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 25
			INVOKE GdipDrawImageRectI, graphics2, hand13Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 26
			INVOKE GdipDrawImageRectI, graphics2, hand14Img, eax, ebx, -224, 192
			dec man2.frame1
		.elseif man2.frame1 == 27
			INVOKE GdipDrawImageRectI, graphics2, hand15Img, eax, ebx, -224, 192
			dec man2.frame1
		.endif
	.endif
	ret
DrawMan ENDP

; 根据球的位置绘制球
DrawBall PROC
	mov ebx, OFFSET threePoint
	mov eax, bad.mx
	add eax, bx1
	mov [ebx], eax
	mov eax, bad.my
	add eax, by1
	mov [ebx + 4], eax

	mov eax, bad.mx
	add eax, bx2
	mov [ebx + 8], eax
	mov eax, bad.my
	add eax, by2
	mov [ebx + 12], eax

	mov eax, bad.mx
	add eax, bx3
	mov [ebx + 16], eax
	mov eax, bad.my
	add eax, by3
	mov [ebx + 20], eax
	; 绘制球
	INVOKE GdipDrawImagePointsI, graphics2, ballImg, ADDR threePoint, 3
	ret
DrawBall ENDP

DrawPoint PROC
	.if man1.point == 0
		INVOKE GdipDrawImageRectI, graphics2, point0Img, 411, 40, 40, 50
	.elseif man1.point == 1
		INVOKE GdipDrawImageRectI, graphics2, point1Img, 411, 40, 40, 50
	.elseif man1.point == 2
		INVOKE GdipDrawImageRectI, graphics2, point2Img, 411, 40, 40, 50
	.elseif man1.point == 3
		INVOKE GdipDrawImageRectI, graphics2, point3Img, 411, 40, 40, 50
	.elseif man1.point == 4
		INVOKE GdipDrawImageRectI, graphics2, point4Img, 411, 40, 40, 50
	.elseif man1.point == 5
		INVOKE GdipDrawImageRectI, graphics2, point5Img, 411, 40, 40, 50
	.endif

	.if man2.point == 0
		INVOKE GdipDrawImageRectI, graphics2, point0Img, 465, 40, 40, 50
	.elseif man2.point == 1
		INVOKE GdipDrawImageRectI, graphics2, point1Img, 465, 40, 40, 50
	.elseif man2.point == 2
		INVOKE GdipDrawImageRectI, graphics2, point2Img, 465, 40, 40, 50
	.elseif man2.point == 3
		INVOKE GdipDrawImageRectI, graphics2, point3Img, 465, 40, 40, 50
	.elseif man2.point == 4
		INVOKE GdipDrawImageRectI, graphics2, point4Img, 465, 40, 40, 50
	.elseif man2.point == 5
		INVOKE GdipDrawImageRectI, graphics2, point5Img, 465, 40, 40, 50

	.endif
	ret
DrawPoint ENDP

DrawOneFrame PROC
	local myrect: RECT        ; 窗口坐标
	local paint: PAINTSTRUCT
	.if chooseMode == 1
		mov picture, 1
	.endif
	INVOKE InvalidateRect, hWnd, NULL , 0
	ret
DrawOneFrame ENDP

; 隔10ms更新游戏状态
RefreshStatus PROC
	inc clock
	call DrawOneFrame
	call BallMove              ; 更新球的位置
	call ManMove               ; 更新角色位置
	call CheckHitBall          ; 检查是否击中
	; 计算E
	.if leftAuto == 1
		call GuanGong
	.endif
	.if rightAuto == 1
		call QinQiong
	.endif
	; 判断是否有玩家获胜
	.if man1.point == 5
		mov man1.point, 0
		mov man2.point, 0
		mov oneWin, 1
		; 弹出消息框: 玩家获胜
		INVOKE MessageBox, hWnd, ADDR leftWin, ADDR MsgCaption, MB_OK
		mov chooseMode, 1
		INVOKE DrawChooseMode
	.endif
	.if man2.point == 5
		mov man1.point, 0
		mov man2.point, 0
		mov oneWin, 1
		; 弹出消息框: 玩家获胜
		INVOKE MessageBox, hWnd, ADDR rightWin, ADDR MsgCaption, MB_OK
		mov chooseMode, 1
		INVOKE DrawChooseMode  ; 游戏结束, 重新选择模式
	.endif
	ret
RefreshStatus ENDP

Paint PROC
local paint: PAINTSTRUCT
	push ebx
	INVOKE BeginPaint, hWnd, ADDR paint
	mov hDC, eax

	INVOKE GdipCreateFromHDC, hDC, ADDR graphics
	.if picture == 0
		INVOKE Picture           ; 获取图片
		INVOKE DrawTitle
		mov picture, 1           ; 标志图片已被读取
	.else
		.if drawTitle == 1       ; 绘制标题
			INVOKE DrawTitle
		.elseif chooseMode == 1  ; 选择游戏模式
			INVOKE DrawChooseMode
			INVOKE InvalidateRect, hWnd, NULL , 0
		.else
			INVOKE CreateCompatibleDC, bitmaphdc
			mov bitmaphdc, eax
			INVOKE CreateCompatibleBitmap, hDC, 900, 600
			mov mybitmap, eax
			INVOKE SelectObject, bitmaphdc, mybitmap

			mov oldbitmap, eax

			INVOKE GdipCreateFromHDC, bitmaphdc, ADDR graphics2
			INVOKE GdipDrawImageRectI, graphics2, backImg, 0, 0, 900, 600
			INVOKE DrawPoint
			INVOKE DrawMan, 1
			INVOKE DrawMan, 2
			INVOKE DrawBall
			INVOKE BitBlt, hDC, 0, 0, 900, 600, bitmaphdc, 0, 0, SRCCOPY
			INVOKE GdipDeleteGraphics, graphics2

			INVOKE SelectObject, bitmaphdc, oldbitmap

			INVOKE DeleteObject, mybitmap
			INVOKE DeleteDC, bitmaphdc
		.endif
	.endif
	INVOKE GdipReleaseDC, graphics, hDC
	INVOKE GdipDeleteGraphics, graphics
	INVOKE EndPaint, hWnd, ADDR paint

	pop ebx
	ret
Paint ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;; 数学运算
; 计算平方根——FpuSqrt
Sqrt PROC x: SDWORD
.data
	src SDWORD ?
	res TBYTE ?  ; 浮点
.code
	mov eax, x
	mov src, eax
	; 计算src的平方根存储在res中
	INVOKE FpuSqrt, ADDR src, ADDR res, SRC1_DMEM or DEST_MEM
	; 取整数存入src中
	INVOKE FpuRound, ADDR res, ADDR src, SRC1_REAL or DEST_IMEM
	mov eax, src
	ret
Sqrt ENDP

; 欧几里得距离 \sqrt{(x2 - x1) ^ 2 + (y2 - y1) ^ 2}
GetDistance PROC x1: SDWORD, y1: SDWORD, x2: SDWORD, y2: SDWORD
	mov eax, x2
	sub eax, x1
	mov ebx, y2
	sub	ebx, y1
	imul eax
	mov ecx, eax
	mov eax, ebx
	imul ebx
	mov ebx, eax
	mov eax, ecx
	add ebx, eax
	INVOKE Sqrt, ebx
	ret               ; return eax
GetDistance ENDP

; 计算单精度浮点数的加减乘除
FPlus PROC, r1: REAL4, r2: REAL4
	 fld r1
	 fld r2
	 FADD
	 ret
FPlus ENDP
FSubt PROC, r1: REAL4, r2: REAL4
	fld r1
	fld r2
	FSUB
	ret
FSubt ENDP
FMult PROC, r1: REAL4, r2: REAL4
	fld r1
	fld r2
	FMUL
	ret
FMult ENDP
FDivi PROC, r1: REAL4, r2: REAL4
	fld r1
	fld r2
	FDIV
	ret
FDivi ENDP

SinCos PROC a: SDWORD, degree: SDWORD
.data
	t TBYTE ?    ; 十进制浮点数, 保存中间计算结果
	sin SDWORD ?
	cos SDWORD ?
.code
	INVOKE FpuSin, degree, ADDR t, SRC1_DIMM                              ; t = sin(degree)
	INVOKE FpuMul, ADDR t, a, ADDR t, SRC1_REAL or SRC2_DIMM or DEST_MEM  ; t = a * sin(degree)
	INVOKE FpuRound, ADDR t, ADDR sin, DEST_IMEM or SRC1_REAL             ; sin = round(t)
	INVOKE FpuCos, degree, ADDR t, SRC1_DIMM                              ; t = cos(degree)
	INVOKE FpuMul, ADDR t, a, ADDR t, SRC1_REAL or SRC2_DIMM or DEST_MEM  ; t = a * cos(degree)
	INVOKE FpuRound, ADDR t, ADDR cos, DEST_IMEM or SRC1_REAL             ; cos = round(t)
	mov eax, sin  ; eax = sin
	mov ebx, cos  ; ebx = cos
	ret
SinCos ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
; 球的状态
; 出界
BallOutBound PROC
	finit
	inc bad.hitTime
	mov bad.cantHit, 1

	; FIXME 统计次数
	.if bad.hitTime == 1
		; 计分
		.if ballPreX < midWidth
			inc man1.point
		.else
			inc man2.point
		.endif
	.endif
	; 重新发球
	.if ballPreX < midWidth
		mov ballPre, 1
	.else
		mov ballPre, 2
	.endif
	ret
BallOutBound ENDP

; 球落地
; 改变得分 + 重新发球
BallHitGround PROC
	finit
	inc bad.hitTime
	mov bad.cantHit, 1

	; FIXME 统计次数
	.if bad.hitTime == 1
		; 计分
		.if ballPreX < midWidth
			inc man2.point
		.else
			inc man1.point
		.endif
	.endif
	; 重新发球
	.if ballPreX < midWidth
		mov ballPre, 2
	.else
		mov ballPre, 1
	.endif
	ret
BallHitGround ENDP

; 球触网
BallHitNet PROC
.data
	two REAL4 2.
.code
	finit  ; 清空浮点数寄存器!!!
	INVOKE FSubt, zero, bad.mvx
	fst bad.mvx
	INVOKE FDivi, bad.mvx, two
	fst bad.mvx

	sub bad.mx, wWidth
	neg bad.mx

	ret
BallHitNet ENDP

; 停球
BallStop PROC
	finit
	mov bad.my, groundHeight
	fld zero
	; 清空速度和加速度
	fst bad.mvx
	fld zero
	fst bad.mvy
	fld zero
	fst bad.max
	fld zero
	fst bad.may
	.if oneWin == 0
		dec hitGroundTimer
	.endif
	; FIXME hitTime清零
	.if hitGroundTimer == 0
		mov bad.hitTime, 0
		mov hitGroundTimer, 10  ; 稍等一会儿
		mov bad.cantHit, 0
	.else
		ret
	.endif
	mov al, ballPre
	mov startHit, al
	.if bad.mx < midWidth
		mov ecx, man2.mx
		mov edx, man2.my
		add ecx, RacketX
		sub edx, RacketY
		mov leftHitting, 0
		mov rightHitting, 1
	.else
		mov ecx, man1.mx
		mov edx, man1.my
		sub ecx, RacketX
		sub edx, RacketY
		mov rightHitting, 0
		mov leftHitting, 1
	.endif
	ret
BallStop ENDP

; 检测球的状态
CheckBallStatus PROC uses eax ebx ecx edx esi
	; 落地
	.if bad.my > groundHeight
		call BallHitGround
	.endif
	; 出界
	.if bad.mx > wWidth - ballLimit || bad.mx < ballLimit
		call BallOutBound
	.endif
	; 触网
	.if (bad.mx >= midWidth && ballPreX <= midWidth) || (bad.mx <= midWidth && ballPreX >= midWidth)
		.if bad.my >= netHeight && bad.my <= groundHeight && ballPreY >= netHeight && ballPreY <= groundHeight
			call BallHitNet
		.endif
	.endif
	; 停止反弹
	.if bad.hitTime > 2
		call BallStop
	.endif
	ret
CheckBallStatus ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
; 球的运动
; 计算当前球的角度
BallDegree PROC
.data
	angle TBYTE	 ?
	tmpvx SDWORD ?
	tmpvy SDWORD ?
	tmpa REAL4	 100.
.code
	finit
	; 缩放vx
	fld bad.mvx
	fld tmpa
	fmul
	fist tmpvx  ; 缩放后的水平速度
	; 缩放vy
	fld bad.mvy
	fld tmpa
	fmul
	fist tmpvy  ; 缩放后的垂直速度

	.if tmpvx == 0 && tmpvy < 0      ; 垂直下落
		INVOKE FpuAdd, 0, -90, ADDR bad.deg, SRC1_DIMM or SRC2_DIMM  ; ↓
		call BallThreePoint
		ret
	.else
		INVOKE FpuDiv, ADDR tmpvy, ADDR tmpvx, 0, SRC1_DMEM or SRC2_DMEM or DEST_FPU
		INVOKE FpuArctan, 0, ADDR angle, SRC1_FPU  ; 计算方向
		.if tmpvx < 0
			INVOKE FpuAdd, 180, ADDR angle, ADDR bad.deg, SRC1_DIMM or SRC2_REAL
		.else
			INVOKE FpuAdd, 0, ADDR angle, ADDR bad.deg, SRC1_DIMM or SRC2_REAL
		.endif
	.endif
	call BallThreePoint
	ret
BallDegree ENDP

; 计算球的速度和加速度
BallMove PROC uses eax
	.if startHit == 0
		finit
		INVOKE FMult, bad.mvx, af
		fst bad.max
		INVOKE FSubt, zero, bad.max
		fst bad.max                     ; max = - mvx * af
		INVOKE FPlus, bad.mvx, bad.max
		fst bad.mvx                     ; mvx  + = max
		fist tmvx
		mov eax, bad.mx
		mov ballPreX, eax
		add eax, tmvx                   ; mx  + = mvx
		mov bad.mx, eax

		INVOKE FMult, bad.mvy, af
		fst bad.may
		INVOKE FSubt, ab, bad.may
		fst bad.may                     ; may = ab - mvy * af
		INVOKE FPlus, bad.mvy, bad.may
		fst bad.mvy                     ; mvy  + = may
		fist tmvy
		mov eax, bad.my
		mov ballPreY, eax
		add eax, tmvy
		mov bad.my, eax                 ; my  + = mvy

		call BallDegree                 ; 计算球移动后的角度
		call CheckBallStatus            ; 检测球移动后状态
	.else
		.if startHit == 1
			mov eax, man1.mx
			add eax, ballPos            ; 发球位置
			mov bad.mx, eax
			mov bad.my, 520
		.else
			mov eax, man2.mx
			sub eax, ballPos
			mov bad.mx, eax
			mov bad.my, 520
		.endif
	.endif
	ret
BallMove ENDP

; 击球反弹
Rebound PROC uses ebx ecx edx player: SDWORD
	.if player == 1
		mov edx, bad.mx
		.if edx < man1.mx
			mov eax, man1.mx
			sub eax, bad.mx   ; eax = mx - bx
			mov ebx, bad.my
			sub ebx, man1.my  ; ebx = by - my
			.if ebx < 0       ; 球在角色中心下方
				neg ebx
			.endif
			.if ebx < eax
				mov eax, 0
				ret           ; eax = mx - bx
			.endif
		.endif
	.else
		mov edx, bad.mx
		.if edx > man2.mx
			mov eax, bad.mx
			sub eax, man2.mx
			mov ebx, bad.my
			sub ebx, man2.my
			.if ebx < 0
				neg ebx
			.endif
			.if ebx < eax
				mov eax, 0
				ret
			.endif
		.endif
	.endif

	.if player == 1
		INVOKE GetDistance, man1.mx, man1.my, bad.mx, bad.my
	.else
		INVOKE GetDistance, man2.mx, man2.my, bad.mx, bad.my
	.endif

	.if eax >= 40 && eax <= 150
		mov edx, 0
		mov ecx, 120
		imul velocity 	; 速度 / v = 距离 / 拍长
		idiv ecx
		ret
	.endif
	mov eax, 0
	ret
Rebound ENDP

; 三点定位
BallThreePoint PROC
	;球半对角线长:28
.data
	tmpdeg	TBYTE	?
	tmpt	SDWORD	?
.code
	INVOKE FpuAdd, 45, ADDR bad.deg, ADDR tmpdeg, SRC1_DIMM or SRC2_REAL  ; tmpdeg = bad.deg + 45
	INVOKE FpuRound, ADDR tmpdeg, ADDR tmpt, SRC1_REAL or DEST_IMEM
	INVOKE SinCos, 28, tmpt  ; ebx = r * cos(tmpdeg), eax=r * sin(tmpdeg)
	mov bx2, ebx
	mov by2, eax
	INVOKE FpuAdd, 135, ADDR bad.deg, ADDR tmpdeg, SRC1_DIMM or SRC2_REAL  ; tmpdeg = bad.deg + 135
	INVOKE FpuRound, ADDR tmpdeg, ADDR tmpt, SRC1_REAL or DEST_IMEM
	INVOKE SinCos, 28, tmpt  ; ebx = r * cos(tmpdeg), eax=r * sin(tmpdeg)
	mov bx1, ebx
	mov by1, eax
	INVOKE FpuAdd, 225, ADDR bad.deg, ADDR tmpdeg, SRC1_DIMM or SRC2_REAL  ; tmpdeg = bad.deg + 225
	INVOKE FpuRound, ADDR tmpdeg, ADDR tmpt, SRC1_REAL or DEST_IMEM
	INVOKE SinCos, 28, tmpt  ; ebx = r * cos(tmpdeg), eax=r * sin(tmpdeg)
	mov bx3, ebx
	mov by3, eax
	ret
BallThreePoint ENDP

RefreshBall PROC uses eax, lx: SDWORD, ly: SDWORD, lvx: SDWORD, lvy: SDWORD
	finit
	mov eax, lx
	mov bad.mx, eax
	mov eax, ly
	mov bad.my, eax
	fild lvx
	fst bad.mvx
	fild lvy
	fst bad.mvy
	ret
RefreshBall ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
; 检测击球条件
CheckHitBall PROC
	.if ks == 1
		.if startHit == 1                       ; 左侧角色发球
			mov startHit, 0
			ret
		.endif
		mov ks, 0
		.if man1.hit == 0
			mov ecx, man1.my
			.if bad.my > ecx
				mov man1.frame1, 27
			.else
				mov man1.frame1, 7
			.endif
			mov man1.hit, 1
		.endif
		.if bad.cantHit == 0
			INVOKE Rebound, 1                   ; 左侧角色击球反弹, 计算球速
			.if  bad.mx < midWidth && eax != 0  ; 满足击球条件
				INVOKE ManHitBall, man1.mx, man1.my, bad.mx, bad.my, velocity
			.endif
		.endif
	.endif
	.if kdown == 1                              ; 右侧角色发球
		.if startHit == 2
			mov startHit, 0
			ret
		.endif
		mov kdown, 0
		.if man2.hit == 0
			mov ecx, man2.my
			.if bad.my > ecx
				mov man2.frame1, 27
			.ElSE
				mov man2.frame1, 7
			.endif
			mov man2.hit, 1
		.endif
		.if bad.cantHit == 0
			INVOKE Rebound, 2
			.if bad.mx > midWidth && eax != 0   ; 满足击球条件
				INVOKE ManHitBall, man2.mx, man2.my, bad.mx, bad.my, velocity
			.endif
		.endif
	.endif
	ret
CheckHitBall ENDP

; 击球
ManHitBall PROC uses eax edx mx: SDWORD, my: SDWORD, lx: SDWORD, ly: SDWORD, speed: SDWORD
.data
	lymy2 SDWORD ?
	lxmx2 SDWORD ?
	lymylxmx    SDWORD ?
	a2    SDWORD ?
	b2    SDWORD ?
	a     SDWORD ?        ; 新速度分量
	b     SDWORD ?
.code
	; 求距离
	; (ly - my) ^ 2
	mov eax, ly
	mov lymy2, eax
	mov eax, my
	sub lymy2, eax
	mov eax, lymy2
	imul lymy2
	mov lymy2, eax
	; (lx - mx) ^ 2
	mov eax, lx
	mov lxmx2, eax
	mov eax, mx
	sub lxmx2, eax
	mov eax, lxmx2
	imul lxmx2
	mov lxmx2, eax
	; (ly - my) ^ 2 + (lx - mx) ^ 2
	mov eax, lymy2
	mov lymylxmx, eax
	mov eax, lxmx2
	add lymylxmx, eax

	; 速度分解
	mov eax, speed
	mov edx, 0
	imul speed		; v ^ 2
	imul lymy2		; v ^ 2 * (ly - my) ^ 2
	idiv lymylxmx	; v ^ 2 * (ly - my) ^ 2 / ((ly - my) ^ 2 + (lx - mx) ^ 2)
	mov a2, eax     ; y方向分量平方

	mov eax, speed
	imul speed
	sub eax, a2		; b ^ 2 = v ^ 2 - a ^ 2
	mov b2, eax
	; 开平方
	INVOKE Sqrt, a2
	mov a, eax
	INVOKE Sqrt, b2
	mov b, eax
	mov eax, lx
	.if eax > mx
		neg a
	.endif
	mov eax, ly
	.if eax < my
		neg b
	.endif          ; 得到新的速度分量
	.if mx < midWidth && a < 0
		neg a
		neg b
	.endif
	.if mx > midWidth && a > 0
		neg a
		neg b
	.endif
	; FIXME 略微修正
	.if mx < midWidth
		add a, 10
		sub b, 10
	.else
		sub a, 10
		sub b, 10
	.endif
	mov eax, ly
	.if eax > my
		.if mx < midWidth
			mov a, 30
			mov b, -30
		.else
			mov a, -30
			mov b, -30
		.endif
	.endif

	INVOKE RefreshBall, lx, ly, a, b
	ret
ManHitBall ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;; 角色
; 控制角色移动
ManMove PROC uses eax
.data
	tmpxy REAL4 ?
.code
	; 先保存当前位置
	mov eax, man1.mx
	mov man1preX, eax
	mov eax, man1.my
	mov man1preY, eax
	mov eax, man2.mx
	mov man2preX, eax
	mov eax, man2.my
	mov man2preY, eax

	finit
	.if ka == 1
		fld manvn
		fst man1.mvx
		mov man1.move, 1
	.elseif kd == 1
		fld manvp
		fst man1.mvx
		mov man1.move, 1
	.else
		fld zero
		fst man1.mvx
	.endif
	.if kleft == 1
		fld manvn
		fst man2.mvx
		mov man2.move, 1
	.elseif kright == 1
		fld manvp
		fst man2.mvx
		mov man2.move, 1
	.else
		fld zero
		fst man2.mvx
	.endif
	; 实现角色水平移动
	fild man1.mx
	fst tmpxy
	INVOKE FPlus, tmpxy, man1.mvx
	fist man1.mx
	finit
	fild man2.mx
	fst tmpxy
	INVOKE FPlus, tmpxy, man2.mvx
	fist man2.mx

	; 发球位置限制
	.if startHit == 1 && man1.mx > 250
		mov man1.mx, 250
	.endif
	.if startHit == 2 && man2.mx < wWidth - 250
		mov man2.mx, wWidth - 250
	.endif
	; 防止偷溜走
	.if man1.mx < manLimit
		mov man1.mx, manLimit
	.endif
	; 防止过网击球
	.if man1.mx > midWidth - 80
		mov man1.mx, midWidth - 80
	.endif
	.if man2.mx>wWidth - manLimit
		mov man2.mx, wWidth - manLimit
	.endif
	.if man2.mx < midWidth + 80
		mov man2.mx, midWidth + 80
	.endif
	; 跳跃
	.if kw == 1 && man1.my == netHeight
		mov kw, 0
	 	fld manjmpv
		fst man1.mvy
	.endif
	.if kup == 1 && man2.my == netHeight
		mov kup, 0
		fld manjmpv
		fst man2.mvy
	.endif
	; 垂直速度变化
	finit
	INVOKE FSubt, man1.mvy, ag
	fst man1.mvy
	INVOKE FSubt, man2.mvy, ag
	fst man2.mvy

	fild man1.my
	fst tmpxy
	INVOKE FSubt, tmpxy, man1.mvy
	fist man1.my
	; 防止下地狱
	.if man1.my > netHeight
		mov man1.my, netHeight
		fld zero
		fst man1.mvy
	.endif
	fild man2.my
	fst tmpxy
	INVOKE FSubt, tmpxy, man2.mvy
	fist man2.my
	.if man2.my > netHeight
		mov man2.my, netHeight
		fld zero
		fst man2.mvy
	.endif
	ret
ManMove ENDP

; E逻辑
GuanGong PROC
.data
	tmpLeft DWORD ?
.code
	.if bad.mx > midWidth       ; 球位于中线右侧, leftHitting置零, 不击球
		mov leftHitting, 0
		; 保持在左侧场地1/2处
		.if man1.mx > midWidth / 3
			mov ka, 1
			mov kd, 0
		.elseif man1.mx < midWidth / 3
			mov kd, 1
			mov ka, 0
		.else
			mov ka, 0
			mov kd, 0
		.endif
	.else
		; 球来到左侧, 向球靠近
		mov eax, man1.mx
		add eax, 60
		mov ebx, man1.mx
		sub ebx, 60
		.if bad.mx > eax
			mov kd, 1
			mov ka, 0
		.elseif bad.mx < ebx
			mov ka, 1
			mov kd, 0
		.else
			mov ka, 0
			mov kd, 0
		.endif
	.endif
	.if leftHitting == 0
		; 判断距离, 准备击球
		INVOKE GetDistance, bad.mx, bad.my, man1.mx, man1.my
		mov tmpLeft, eax
		.if	tmpLeft < 100 && tmpLeft > 50
			mov ks, 1           ; 距离50-100 击球
			mov leftHitting, 1  ; 标记已击球(防止一直挥拍子!!!)
		.endif
	.endif
	ret
GuanGong ENDP
QinQiong PROC
.data
	tmpRight DWORD ?
.code
	.if bad.mx < midWidth
		mov rightHitting, 0
		; 保持在右侧场地1/3处
		mov eax, midWidth + midWidth * 2 / 3
		add eax, 50
		mov ebx, midWidth + midWidth * 2 / 3
		sub ebx, 50
		.if man2.mx > eax
			mov kright, 0
			mov kleft, 1
		.elseif man2.mx < ebx
			mov kleft, 0
			mov kright, 1
		.else
			mov kleft, 0
			mov kright, 0
		.endif
	.else
		; 球来到右侧
		mov eax, man2.mx
		add eax, 50
		mov ebx, man2.mx
		sub ebx, 50
		mov ecx, bad.mx
		.if ecx > eax
			mov kright, 1
			mov kleft, 0
		.elseif ecx < ebx
			mov kleft, 1
			mov kright, 0
		.else
			mov kleft, 0
			mov kright, 0
		.endif
	.endif
	.if rightHitting == 0
		INVOKE GetDistance, bad.mx, bad.my, man2.mx, man2.my
		mov tmpRight, eax
		.if	tmpRight < 120 && tmpRight > 40
			mov kdown, 1
			mov rightHitting, 1
		.endif
	.endif
	ret
QinQiong ENDP
;-------------------------------------------------------------------------------
;; 事件处理
; 检测方向键的按下与松开
KeyUp PROC vk: WPARAM
	.if leftAuto == 0           ; 左侧P
		; 检测WASD按键
		.if vk ==  VK_W
			mov kw, 0
		.elseif vk == VK_A
			mov ka, 0
		.elseif vk == VK_S
			mov ks, 0
		.elseif vk == VK_D
			mov kd, 0
		.endif
	.endif
	.if rightAuto == 0          ; 右侧P
		; 检测↑←↓→按键
		.if vk == VK_UP
			mov kup, 0
		.elseif vk == VK_DOWN
			mov kdown, 0
		.elseif vk == VK_LEFT
			mov kleft, 0
		.elseif vk == VK_RIGHT
			mov kright, 0
		.endif
	.endif
	ret
KeyUp ENDP
KeyDown PROC vk: WPARAM
	.if leftAuto == 0           ; 左侧P
		; 检测wasd按键
		.if vk ==  VK_W
			mov kw, 1
		.elseif vk == VK_A
			mov ka, 1
		.elseif vk == VK_S
			mov ks, 1
		.elseif vk == VK_D
			mov kd, 1
		.endif
	.endif
	.if rightAuto == 0          ; 右侧P
		; 检测↑←↓→按键
		.if vk == VK_UP
			mov kup, 1
		.elseif vk == VK_DOWN
			mov kdown, 1
		.elseif vk == VK_LEFT
			mov kleft, 1
		.elseif vk == VK_RIGHT
			mov kright, 1
		.endif
	.endif
	ret
KeyDown ENDP

; 处理鼠标左键
LButtonUp PROC wParam: WPARAM, lParam: LPARAM
.data?
	; 鼠标释放时的坐标
	mousex SWORD ?
	mousey SWORD ?
.code
	.if drawTitle == 1
		mov drawTitle, 0
		INVOKE InvalidateRect, hWnd, NULL , 0  ; 重新绘制窗口
		ret
	.endif

	mov eax, lParam                            ; 高16位-y, 低16位-x
	mov mousex, ax                             ; 提取鼠标坐标
	shr eax, 16
	mov mousey, ax

	; 检查鼠标是否位于界面范围内
	.if mousex < 600 && mousex > 300
		; 选择游戏模式并开始游戏
		; PVP
		.if mousey > 320 && mousey < 380
			mov leftAuto, 0
			mov rightAuto, 0
			mov chooseMode, 0
			call InitGame
		; PVE
		.elseif mousey > 380 && mousey < 440
			mov leftAuto, 0
			mov rightAuto, 1
			mov chooseMode, 0
			call InitGame
		; EVP
		.elseif mousey > 440 && mousey < 500
			mov leftAuto, 1
			mov rightAuto, 0
			mov chooseMode, 0
			call InitGame
		.endif
	.endif

	; 退出游戏
	.if mousex < 900 && mousex > 800 && mousey < 100 && mousey > 0
			mov leftAuto, 0
			mov rightAuto, 0
			mov chooseMode, 1
			INVOKE DrawChooseMode
	.endif

	;XXX 演示模式
	.if mousex < 900 && mousex > 700 && mousey < 600 && mousey > 520
			mov leftAuto, 1
			mov rightAuto, 1
			mov chooseMode, 0
			call InitGame
	.endif
	ret
LButtonUp ENDP

; 开始游戏初始化
InitGame PROC				                                ; 点击开始按钮
	INVOKE GetWindowText, hEdtInterval, ADDR bInterval, lInterval
	INVOKE StrToInt, ADDR bInterval                         ; 设置游戏参数

	INVOKE SetTimer, hWnd, idTimer, 10, ADDR RefreshStatus  ; 间隔10ms调用RefreshStatus
	mov dwTimerId1, eax
	mov man1.point, 0
	mov man2.point, 0
	mov man1.mx, manLimit                                   ; 左侧玩家位置
	mov man1.my, netHeight
	mov man2.mx, wWidth - manLimit - 200                    ; 右侧玩家位置
	mov man2.my, netHeight
	mov hitGroundTimer, 30                                  ; 撞击地面定时器
	mov oneWin, 0                                           ; 胜利标志
	mov startHit, 1                                         ; 发球方
	mov ballPre, 1                                          ; 发球方
	mov leftHitting, 0                                      ; PE是否击中球
	mov rightHitting, 0
	mov bad.hitTime, 0                                      ; 球的状态
	mov bad.cantHit, 0
	mov kw, 0                                               ; 方向键置零
	mov ka, 0
	mov ks, 0
	mov kd, 0
	mov kleft, 0
	mov kright, 0
	mov kup, 0
	mov kdown, 0
	mov clock, 0                                            ; 时钟信号置零

	; FIXME
	; 控制游戏过程中禁止游戏模式选择

	ret
InitGame ENDP

; 处理窗口接收到的消息
WndProc PROC hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	push hwnd
	pop hWnd                               ; 将窗口句柄存储到hWnd
	; 关闭窗口
	.if uMsg == WM_DESTROY
		INVOKE PostQuitMessage, NULL
	; 创建窗口
	.elseif uMsg == WM_CREATE
		INVOKE OnCreate
	; 绘制
	.elseif uMsg == WM_PAINT
		INVOKE Paint
	; 鼠标左键处理
	.elseif uMsg == WM_LBUTTONUP
		INVOKE LButtonUp, wParam, lParam
	.elseif uMsg == WM_COMMAND
		mov eax, wParam                    ; 将wPram移入eax(高位-通知消息, 低位-标识符)
		.if lParam == 0                    ; 无菜单功能
		.else                              ; 消息来源与按钮
			mov ebx, eax
			shr ebx, 16                    ; 获取通知消息
			.if bx == BN_CLICKED           ; 如果点击按钮
				.if ax == IDC_START        ; 按钮是start触发
					INVOKE SetFocus, hWnd
					INVOKE InitGame        ; 开始游戏
				.endif
			.endif
		.endif
	; 按下按键
	.elseif uMsg == WM_KEYDOWN
		INVOKE KeyDown, wParam
	; 松开按键
	.elseif uMsg == WM_KEYUP
		INVOKE KeyUp, wParam
	; 默认窗口处理
	.else
		INVOKE DefWindowProc, hWnd, uMsg, wParam, lParam
     	ret
	.endif
	xor eax, eax  ; return 0
	ret
WndProc ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;; 其它功能
; 播放音乐(PlayAudio)——Windows MCI接口
PlayAudio PROC hWin: DWORD, filename: DWORD
	local mciOpenParms: MCI_OPEN_PARMS, mciPlayParms: MCI_PLAY_PARMS
		mov eax, hWin
		mov mciPlayParms.dwCallback, eax
		mov eax, OFFSET audioPlay
		mov mciOpenParms.lpstrDeviceType, eax
		mov eax, filename
		mov mciOpenParms.lpstrElementName, eax
		INVOKE mciSendCommand, 0, MCI_OPEN, MCI_OPEN_TYPE or MCI_OPEN_ELEMENT, ADDR mciOpenParms
		mov eax, mciOpenParms.wDeviceID
		mov audioPlayID, eax
		INVOKE mciSendCommand, audioPlayID, MCI_PLAY, 00010000h, ADDR mciPlayParms
		ret
PlayAudio ENDP

End Start