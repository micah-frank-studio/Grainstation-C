/*	
	Grainstation C - Granular Live Performance Workstation
	by Micah Frank 2018
	www.micahfrank.com
	https://github.com/chronopolis5k	
	
	Special thanks to 	Iain McCurdy, Rory Walsh and the rest of the Csound community
*/

<CsoundSynthesizer>
<CsOptions>

-Ma ;enable all MIDI devices
;-B512 -b128 ; hardware and software buffer default (-B512 -b128)
;-iadc    ;;;uncomment -iadc if RT audio input is needed too
;-n -d -+rtmidi=NULL -M0 -m0d
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 32
nchnls = 2
0dbfs  = 1

/* 

Config options 
See this video for a quick explanation 
https://www.dropbox.com/s/im1vivrjv98isub/Grainstation-C_config.mp4?dl=0

*/
;;Path to sound files
Sfile1 = "sounds/Maine_Shore.aif"
Sfile2 = "sounds/Violin_BowBounce.aif"
Sfile3 = "sounds/Rhodezart.aif" 
Sfile4 = "sounds/Woodstock_Ice.aif"
gSIRfile = "sounds/IR_StNicolaesChurch.wav" ; Reverb IR file	
;Sfile5 = "sounds/"
;Sfile6 = "sounds/"
;Sfile7 = "sounds/"
;Sfile8 = "sounds/"

ginput = 1 			;INPUT CHANNEL NUMBER

;;B-Format - Ambisonic encoding options
giBEncode = 1 ;Render B-format alongside stereo render? (1 = yes, 0 = no)
giNSpeakers = 9 ;how many speakers?
giNChannels = 14 ;how many channels of audio are we using? (recommended, not to change this!)


;INITIALIZE RECORD BUFFERS	
giRecBuf[] init 4
giRecBuf[0] ftgen	0,0,2^24,-7,0 ;about 5.8 minutes of recording per buffer
giRecBuf[1]	 ftgen	0,0,2^24,-7,0
giRecBuf[2] ftgen	0,0,2^24,-7,0
giRecBuf[3] ftgen	0,0,2^24,-7,0

maxalloc 97,1 ; allow only one instance of the input recorder at a time!

; index file names to integers
strset 0, Sfile1
strset 1, Sfile2
strset 2, Sfile3
strset 3, Sfile4
;strset 4, Sfile5
;strset 5, Sfile6
;strset 6, Sfile7
;strset 7, Sfile8
giwin ftgen 1, 0, 8192, 20, 2, 1  ;Hanning window

;;MIDI definitions

massign 1, 99 ; Route MIDI chn 1 to instr 99
massign 2, 2 ; Route MIDI chn 1 to instr 2
gichan1 = 1 ; MIDI controller channel 1
gichan2 = 2 ; MIDI controller channel 2
gichan3 = 3 ; MIDI controller channel 3
gichan4 = 4 ; MIDI controller channel 4
; Faders
gictrl_lev1 = 77
gictrl_lev2 = 78
gictrl_lev3 = 79
gictrl_lev4 = 80
gictrl_lev5 = 81
gictrl_lev6 = 82
gictrl_lev7 = 83
gictrl_lev8 = 84 ;assigned to morph control (fader 8)
;Pitch
gictrl_pitch1 = 1 
gictrl_pitch2 = 4
gictrl_pitch3 = 7
gictrl_pitch4 = 10
gictrl_pitch5 = 13
gictrl_pitch6 = 16
gictrl_pitch7 = 19
;gictrl_pitch8 = 22 - assigned to morph lfo
;Stretch
gictrl_str1 = 2 
gictrl_str2 = 5
gictrl_str3 = 8
gictrl_str4 = 11
gictrl_str5 = 14 
gictrl_str6 = 17
gictrl_str7 = 20
;gictrl_str8 = 23 -  assigned to morph lfo
;Grain Size
gictrl_grsize1 = 3 
gictrl_grsize2 = 6 
gictrl_grsize3 = 9 
gictrl_grsize4 = 12
gictrl_grsize5 = 15 
gictrl_grsize6 = 18 
gictrl_grsize7 = 21
;gictrl_grsize8 = 24 - assigned to morph lfo
;Grain duration (channel 2)
gictrl_grdur1 = 1 
gictrl_grdur2 = 4 
gictrl_grdur3 = 7 
gictrl_grdur4 = 10
gictrl_grdur5 = 13
gictrl_grdur6 = 16
gictrl_grdur7 = 19
gictrl_grdur8 = 22
; Filter Type
gictrl_filtTyp1 = 2
gictrl_filtTyp2 = 5
gictrl_filtTyp3 = 8
gictrl_filtTyp4 = 11
gictrl_filtTyp5 = 14
gictrl_filtTyp6 = 17
gictrl_filtTyp7 = 20
gictrl_filtTyp8 = 23
; Filter Freq
gictrl_filtFreq1 = 3
gictrl_filtFreq2 = 6
gictrl_filtFreq3 = 9
gictrl_filtFreq4 = 12
gictrl_filtFreq5 = 15
gictrl_filtFreq6 = 18
gictrl_filtFreq7 = 21
gictrl_filtFreq8 = 24
;delay time
gictrl_delay_time1 = 1 ; delay time
gictrl_delay_time2 = 4
gictrl_delay_time3 = 7
gictrl_delay_time4 = 10
gictrl_delay_time5 = 13
gictrl_delay_time6 = 16
gictrl_delay_time7 = 19
gictrl_delay_time8 = 22
; delay feedback
gictrl_fdbk1 = 2 ; delay feedback
gictrl_fdbk2 = 5
gictrl_fdbk3 = 8
gictrl_fdbk4 = 11
gictrl_fdbk5 = 14
gictrl_fdbk6 = 17
gictrl_fdbk7 = 20
gictrl_fdbk8 = 23
;delay pitch shift
gictrl_delayPShift1 = 3 		;delay feedback pitch shift
gictrl_delayPShift2 = 6 
gictrl_delayPShift3 = 9 
gictrl_delayPShift4 = 12
gictrl_delayPShift5 = 15
gictrl_delayPShift6 = 18
gictrl_delayPShift7 = 21
gictrl_delayPShift8 = 24 
;CHANNEL 4
; delay send
gictrl_delaySend1 = 1
gictrl_delaySend2 = 4
gictrl_delaySend3 = 7
gictrl_delaySend4 = 10
gictrl_delaySend5 = 13
gictrl_delaySend6 = 16
gictrl_delaySend7 = 19
gictrl_delaySend8 = 22
; reverb send
gictrl_verbSend1 = 2
gictrl_verbSend2 = 5
gictrl_verbSend3 = 8
gictrl_verbSend4 = 11
gictrl_verbSend5 = 14
gictrl_verbSend6 = 17
gictrl_verbSend7 = 20
gictrl_verbSend8 = 23
; azimuth
gictrl_azi1 = 1
gictrl_azi2 = 4
gictrl_azi3 = 7
gictrl_azi4 = 10
gictrl_azi5 = 13
gictrl_azi6 = 16
gictrl_azi7 = 19
gictrl_azi8 = 22

;altitude
gictrl_alt1 = 2
gictrl_alt2 = 5
gictrl_alt3 = 8
gictrl_alt4 = 11
gictrl_alt5 = 14
gictrl_alt6 = 17
gictrl_alt7 = 20
gictrl_alt8 = 23

;record
gictrl_record = 108 ;note C7 #108
gictrl_kpitchMix = 38
;;snapshots and morph
gkmorphmode init 0
gksnapmode init 0
;snapshots buttons
gistates[] init 9
gistates[0] = 0
gistates[1] = 1
gistates[2] = 2
gistates[3] = 3
gistates[4] = 4
gistates[5] = 5
gistates[6] = 6
gistates[7] = 7
gistates[8] = 8
girec[] fillarray 89, 90, 91, 92			;record button note numbers

gioldnote init 0

gictrl_morphamt = 22
gictrl_morphspd = 23
;save snapshot values to array
gkpos = 300
;snapshots and morph state
gisnpset [] init 9
gimorphon[] init 9
giselected[] init 9

giplayback[] fillarray 0, 0, 0, 0
gkLoopDuration[]	init 4
gitablelength = ftlen(giRecBuf[0])
	
opcode modinit, k, iiiiik ;records all controller information and stores only changed values to position (array).
	ichannel, icontrol, idefault, imin, imax, kmorph xin
	initc7	ichannel, icontrol, idefault ;initialize controller values 
	idft =  (imax+imin)*idefault 						;get real default value	
	kcontrol	ctrl7	ichannel, icontrol, imin, imax ;get current controller value
	kov[] init 9 ;create array for current values (to become old values) 
	kchanged changed gkpos ; has the snapshopt position changed?
	if gksnapmode == 1 && kchanged==1 then ;on snapshot (instr 2), write current value of all changed controls
		kov[gkpos] = kcontrol
		;printks "Snapshot created \n", 0.1
	elseif gksnapmode == 1 && kchanged==0 then ;after snapshot is set, allow morph
		knv = kov[gkpos]
		kcontrol = knv+((kcontrol-knv)*kmorph)
		;prints "Snapshot restored"
		;printk2 knv
	elseif gksnapmode == 2 then
		knv = kov[gkpos]  
		kcontrol = knv+((kcontrol-knv)*kmorph)
	elseif gksnapmode == 0 && kchanged == 0 then								;else assign morph to default values
		kdft =  (imax+imin)*idefault 						;get real default value	
		kcontrol = kdft+((kcontrol-kdft)*kmorph)
	;printks "Snapshot cleared \n", 0.1
	endif
	xout kcontrol
	
	endop
opcode pitchdelay, aa, aaiii ;audio in / audio out, delay time, feedback, delay mix, pitchShift
	ainL, ainR, idelay_time, ifdbk, ipshift xin
	
	imaxdelay = 3; seconds
	
	initc7	gichan3, idelay_time, 0.3	
	kdelay	ctrl7	gichan3, idelay_time, 0.001, imaxdelay
	initc7	gichan3, ifdbk, 0.0	
	kfeedback	ctrl7	gichan3, ifdbk, 0, 0.8
	initc7	gichan3, ipshift, 0.0
	kfbpshift	ctrl7	gichan3, ipshift, 0, 3
	initc7	gichan3, gictrl_kpitchMix, 0.5
	kpitchMix	ctrl7	gichan3, gictrl_kpitchMix, 0, 1	; kpitchmix MIDI in currently disabled - defaults to 50/50
	;printk2 kdelay
	;delay L
	alfoL lfo 0.05, 0.2 ; slightly mod the left delay time
	abuf1		delayr	imaxdelay
	atapL  deltap3    kdelay+alfoL
	delayw ainL + (atapL * kfeedback)
	fftinL  pvsanal   atapL, 1024, 256, 1024, 1 ; analyse it
	ftpsL  pvscale   fftinL, kfbpshift, 1, 2          ; transpose it keeping formants
	atpsL  pvsynth   ftpsL                     ; resynthesis
	
	
	;delay R
	alfoR lfo 0.05, 0.1 ; slightly mod the right delay time
	abuf2		delayr	imaxdelay
	atapR  deltap3    kdelay+alfoR
	delayw  ainR + (atapR * kfeedback)
	fftinR  pvsanal   atapR, 1024, 256, 1024, 1
	ftpsR  pvscale   fftinR, kfbpshift, 1, 2          
	atpsR  pvsynth   ftpsR                    
	
	atapL = atapL + atapR*0.02 ;introduce a little xmodulation
	atapR = atapR + atapL*0.07
	
	;mix between pitched and unpitched delays
	kinvctrl = abs (kpitchMix -1)
	amixL = atapL*kinvctrl + atpsL*kpitchMix
	amixR = atapR*kinvctrl + atpsR*kpitchMix
	
	xout amixL, amixR
endop

opcode mixencoded, 0, akk
	ain, kalpha, kbeta xin
	ipos init 0
	abenc[] init giNSpeakers
	abenc bformenc1 ain, kalpha, kbeta
	/*mixbformat:	
  		if ipos = < giNSpeakers then
  		SchannelName sprintf "benc%i", ipos
			chnmix abenc[ipos], SchannelName
			ipos +=1
			prints SchannelName
			goto mixbformat
			endif
		amix chnget "benc0"
		fout "mix.wav", 24, amix*/
	chnmix abenc[0], "benc0"
	chnmix abenc[1], "benc1"
	chnmix abenc[2], "benc2" 
	chnmix abenc[3], "benc3" 
	chnmix abenc[4], "benc4" 
	chnmix abenc[5], "benc5" 
	chnmix abenc[6], "benc6" 
	chnmix abenc[7], "benc7" 
 	
endop
instr grainwave, 1

ain inch ginput			; input channel
ichncount init 0

;modinit ichannel, icontrol, idefault, imin, imax
;;midi initializations
;morph fader
initc7	gichan1, gictrl_lev8, 1	
kmorph	ctrl7	gichan1, gictrl_lev8, 0.07, 1 ; LEAVE MIN AT 0.07 TO AVOID SERIOUS DISTORTION!!

initc7	gichan1, gictrl_morphamt, 0											;morph lfo amount and speed
kmorphamt	ctrl7	gichan1, gictrl_morphamt, 0.01, 1

initc7	gichan1, gictrl_morphspd, 0	
kmorphspd	ctrl7	gichan1, gictrl_morphspd, 0.25, .003 ;min 4 sec, max 5 minutes lfo speed

;volume faders
ilevdft = 0.0
klev[] init 8
klev[0] modinit 1, gictrl_lev1, ilevdft, 0, 0.1, kmorph
klev[1] modinit 1, gictrl_lev2, ilevdft, 0, 0.1, kmorph
klev[2] modinit 1, gictrl_lev3, ilevdft, 0, 0.1, kmorph
klev[3] modinit 1, gictrl_lev4, ilevdft, 0, 0.1, kmorph
klev[4] modinit 1, gictrl_lev5, ilevdft, 0, 0.1, kmorph
klev[5] modinit 1, gictrl_lev6, ilevdft, 0, 0.1, kmorph
klev[6] modinit 1, gictrl_lev7, ilevdft, 0, 0.1, kmorph
;pitch
ipitchdft = 0.53
gkpitch[] init 8
gkpitch[0] modinit 1, gictrl_pitch1, ipitchdft, -2, 2, kmorph
gkpitch[1] modinit 1, gictrl_pitch2, ipitchdft, -2, 2, kmorph
gkpitch[2] modinit 1, gictrl_pitch3, ipitchdft, -2, 2, kmorph
gkpitch[3] modinit 1, gictrl_pitch4, ipitchdft, -2, 2, kmorph
gkpitch[4] modinit 1, gictrl_pitch5, ipitchdft, -2, 2, kmorph
gkpitch[5] modinit 1, gictrl_pitch6, ipitchdft, -2, 2, kmorph
gkpitch[6] modinit 1, gictrl_pitch7, ipitchdft, -2, 2, kmorph
;gkpitch[7] modinit 1, gictrl_pitch8, ipitchdft, -1, 2, kmorph
;stretch
istrdft = 0.5
kstr1 modinit 1, gictrl_str1, istrdft, 2, 0.01, kmorph
kstr2 modinit 1, gictrl_str2, istrdft, 2, 0.01, kmorph
kstr3 modinit 1, gictrl_str3, istrdft, 2, 0.01, kmorph
kstr4 modinit 1, gictrl_str4, istrdft, 2, 0.01, kmorph
kstr5 modinit 1, gictrl_str5, istrdft, 2, 0.01, kmorph
kstr6 modinit 1, gictrl_str6, istrdft, 2, 0.01, kmorph
kstr7 modinit 1, gictrl_str7, istrdft, 2, 0.01, kmorph
;kstr8 modinit 1, gictrl_str8, istrdft, 2, 0.01, kmorph 
	
;Grain Size
igrsizdft = 0.5 
kgrsize1 modinit 1, gictrl_grsize1, igrsizdft, 0.1, 1, kmorph 
kgrsize2 modinit 1, gictrl_grsize2, igrsizdft, 0.1, 1, kmorph 
kgrsize3 modinit 1, gictrl_grsize3, igrsizdft, 0.1, 1, kmorph 
kgrsize4 modinit 1, gictrl_grsize4, igrsizdft, 0.1, 1, kmorph 
kgrsize5 modinit 1, gictrl_grsize5, igrsizdft, 0.1, 1, kmorph 
kgrsize6 modinit 1, gictrl_grsize6, igrsizdft, 0.1, 1, kmorph 
kgrsize7 modinit 1, gictrl_grsize7, igrsizdft, 0.1, 1, kmorph 
;kgrsize8 modinit 1, gictrl_grsize8, igrsizdft, 0.1, 1, kmorph 
	
;Grain Density (grains per sec)
idensdft = 0.5
kdens1 modinit 2, gictrl_grdur1, idensdft, 2, 32, kmorph
kdens2 modinit 2, gictrl_grdur2, idensdft, 2, 32, kmorph
kdens3 modinit 2, gictrl_grdur3, idensdft, 2, 32, kmorph
kdens4 modinit 2, gictrl_grdur4, idensdft, 2, 32, kmorph
kdens5 modinit 2, gictrl_grdur5, idensdft, 2, 32, kmorph
kdens6 modinit 2, gictrl_grdur6, idensdft, 2, 32, kmorph
kdens7 modinit 2, gictrl_grdur7, idensdft, 2, 32, kmorph
;kdens8 modinit 2, gictrl_grdur8, idensdft, 2, 32, kmorph
;Filter Type
itypdft = 0.001
kfiltType1 modinit 2, gictrl_filtTyp1, itypdft, 0, 1, kmorph
kfiltType2 modinit 2, gictrl_filtTyp2, itypdft, 0, 1, kmorph
kfiltType3 modinit 2, gictrl_filtTyp3, itypdft, 0, 1, kmorph
kfiltType4 modinit 2, gictrl_filtTyp4, itypdft, 0, 1, kmorph
kfiltType5 modinit 2, gictrl_filtTyp5, itypdft, 0, 1, kmorph
kfiltType6 modinit 2, gictrl_filtTyp6, itypdft, 0, 1, kmorph
kfiltType7 modinit 2, gictrl_filtTyp7, itypdft, 0, 1, kmorph
;kfiltType8 modinit 2, gictrl_filtTyp8, itypdft, 0, 1, kmorph
	
	aFilt1L[] init 2
	aFilt1R[] init 2
	aFilt2L[] init 2
	aFilt2R[] init 2
	aFilt3L[] init 2
	aFilt3R[] init 2
	aFilt4L[] init 2
	aFilt4R[] init 2
	aFilt5[] init 2
	aFilt6[] init 2
	aFilt7[] init 2
	;aFilt5L[] init 2
	;aFilt5R[] init 2
	;aFilt6L[] init 2
	;aFilt6R[] init 2
	;aFilt7L[] init 2
	;aFilt7R[] init 2
	;aFilt8L[] init 2
	;aFilt8R[] init 2
	
;Filter Freq
ifltfqdft = 0.999
kfiltFreq1 modinit 2, gictrl_filtFreq1, ifltfqdft, 200, 10000, kmorph
kfiltFreq2 modinit 2, gictrl_filtFreq2, ifltfqdft, 200, 10000, kmorph
kfiltFreq3 modinit 2, gictrl_filtFreq3, ifltfqdft, 200, 10000, kmorph
kfiltFreq4 modinit 2, gictrl_filtFreq4, ifltfqdft, 200, 10000, kmorph
kfiltFreq5 modinit 2, gictrl_filtFreq5, ifltfqdft, 200, 10000, kmorph
kfiltFreq6 modinit 2, gictrl_filtFreq6, ifltfqdft, 200, 10000, kmorph
kfiltFreq7 modinit 2, gictrl_filtFreq7, ifltfqdft, 200, 10000, kmorph
kfiltFreq8 modinit 2, gictrl_filtFreq8, ifltfqdft, 200, 10000, kmorph
;Verb Send
ivrbsnddft = 0.001
kverbsend1 modinit 4, gictrl_verbSend1, ivrbsnddft, 0, 0.1, kmorph
kverbsend2 modinit 4, gictrl_verbSend2, ivrbsnddft, 0, 0.1, kmorph
kverbsend3 modinit 4, gictrl_verbSend3, ivrbsnddft, 0, 0.1, kmorph
kverbsend4 modinit 4, gictrl_verbSend4, ivrbsnddft, 0, 0.1, kmorph
kverbsend5 modinit 4, gictrl_verbSend5, ivrbsnddft, 0, 0.1, kmorph
kverbsend6 modinit 4, gictrl_verbSend6, ivrbsnddft, 0, 0.1, kmorph
kverbsend7 modinit 4, gictrl_verbSend7, ivrbsnddft, 0, 0.1, kmorph
kverbsend8 modinit 4, gictrl_verbSend8, ivrbsnddft, 0, 0.1, kmorph
;Delay Send
idlsnddft = 0.001
kdelsend1 modinit 4, gictrl_delaySend1, idlsnddft, 0, 0.7, kmorph
kdelsend2 modinit 4, gictrl_delaySend2, idlsnddft, 0, 0.7, kmorph
kdelsend3 modinit 4, gictrl_delaySend3, idlsnddft, 0, 0.7, kmorph
kdelsend4 modinit 4, gictrl_delaySend4, idlsnddft, 0, 0.7, kmorph
kdelsend5 modinit 4, gictrl_delaySend5, idlsnddft, 0, 0.7, kmorph
kdelsend6 modinit 4, gictrl_delaySend6, idlsnddft, 0, 0.7, kmorph
kdelsend7 modinit 4, gictrl_delaySend7, idlsnddft, 0, 0.7, kmorph
kdelsend8 modinit 4, gictrl_delaySend8, idlsnddft, 0, 0.7, kmorph		

; Azimuth

iazidft = 0
kalpha1 modinit 5, gictrl_azi1, iazidft, 0, 720, kmorph
kalpha2 modinit 5, gictrl_azi2, iazidft, 0, 720, kmorph
kalpha3 modinit 5, gictrl_azi3, iazidft, 0, 720, kmorph
kalpha4 modinit 5, gictrl_azi4, iazidft, 0, 720, kmorph
kalpha5 modinit 5, gictrl_azi5, iazidft, 0, 720, kmorph
kalpha6 modinit 5, gictrl_azi6, iazidft, 0, 720, kmorph
kalpha7 modinit 5, gictrl_azi7, iazidft, 0, 720, kmorph
kalpha8 modinit 5, gictrl_azi8, iazidft, 0, 720, kmorph	

; Altitude

ialtdft = 0
kbeta1 modinit 5, gictrl_alt1, ialtdft, 0, 720, kmorph
kbeta2 modinit 5, gictrl_alt2, ialtdft, 0, 720, kmorph
kbeta3 modinit 5, gictrl_alt3, ialtdft, 0, 720, kmorph
kbeta4 modinit 5, gictrl_alt4, ialtdft, 0, 720, kmorph
kbeta5 modinit 5, gictrl_alt5, ialtdft, 0, 720, kmorph
kbeta6 modinit 5, gictrl_alt6, ialtdft, 0, 720, kmorph
kbeta7 modinit 5, gictrl_alt7, ialtdft, 0, 720, kmorph
kbeta8 modinit 5, gictrl_alt8, ialtdft, 0, 720, kmorph



	
	giL[] init 8 ;one alloc per channel/ftable
	giR[] init 8
	iFileArrLen = lenarray(giL)
	iolaps  = 2
	ips     = 1/iolaps	
	icount init 0
	loadsounds:
	if icount < iFileArrLen then
		Sname strget icount
		ichn filenchnls Sname ;get number of channels. if mono then load up chn 1 twice.
		if ichn = 2 then
			giL[icount] ftgen 0, 0, 0, 1, Sname, 0, 0, 1
			giR[icount] ftgen 0, 0, 0, 1, Sname, 0, 0, 2
			prints "is stereo \n"
		else 
			giL[icount] ftgen 0, 0, 0, 1, Sname, 0, 0, 1	
			giR[icount] ftgen 0, 0, 0, 1, Sname, 0, 0, 1
		endif
		icount +=1
		goto loadsounds
	endif
  
  
  ;;load f-tables
  	a1L syncloop klev[0], kdens1, gkpitch[0], kgrsize1, ips*kstr1, 0, ftlen(giL[0])/sr, giL[0], 1, iolaps
		a1R syncloop klev[0], kdens1, gkpitch[0], kgrsize1, ips*kstr1, 0, ftlen(giL[0])/sr, giR[0], 1, iolaps
		a2L syncloop klev[1], kdens2, gkpitch[1], kgrsize2, ips*kstr2, 0, ftlen(giL[1])/sr, giL[1], 1, iolaps
		a2R syncloop klev[1], kdens2, gkpitch[1], kgrsize2, ips*kstr2, 0, ftlen(giL[1])/sr, giR[1], 1, iolaps
		a3L syncloop klev[2], kdens3, gkpitch[2], kgrsize3, ips*kstr3, 0, ftlen(giL[2])/sr, giL[2], 1, iolaps
		a3R syncloop klev[2], kdens3, gkpitch[2], kgrsize3, ips*kstr3, 0, ftlen(giL[2])/sr, giR[2], 1, iolaps
		a4L syncloop klev[3], kdens4, gkpitch[3], kgrsize4, ips*kstr4, 0, ftlen(giL[3])/sr, giL[3], 1, iolaps
		a4R syncloop klev[3], kdens4, gkpitch[3], kgrsize4, ips*kstr4, 0, ftlen(giL[3])/sr, giR[3], 1, iolaps
		;Live Input channels.
		a5 syncloop klev[4], kdens5, gkpitch[4], kgrsize5, ips*kstr5, 0, gkLoopDuration[0], giRecBuf[0], 1, iolaps
		a6 syncloop klev[5], kdens6, gkpitch[5], kgrsize6, ips*kstr6, 0, gkLoopDuration[1], giRecBuf[1], 1, iolaps		
		a7 syncloop klev[6], kdens7, gkpitch[6], kgrsize7, ips*kstr7, 0, gkLoopDuration[2], giRecBuf[2], 1, iolaps
		
		;Extra Disk channels if needed
		;a6R syncloop klev[5], kdens6, gkpitch[5], kgrsize6, ips*kstr6, 0, ftlen(giL[5])/sr, giR[5], 1, iolaps		
		;a7L syncloop klev[6], kdens7, gkpitch[6], kgrsize7, ips*kstr7, 0, ftlen(giL[6])/sr, giL[6], 1, iolaps
		;a7R syncloop klev[6], kdens7, gkpitch[6], kgrsize7, ips*kstr7, 0, ftlen(giL[6])/sr, giR[6], 1, iolaps		
		;a8L syncloop klev8, kdens8, kpitch8, kgrsize8, ips*kstr8, 0, ftlen(giL[7])/sr, giL[7], 1, iolaps
		;a8R syncloop klev8, kdens8, kpitch8, kgrsize8, ips*kstr8, 0, ftlen(giL[7])/sr, giR[7], 1, iolaps
	

  	kq = 0
  	alow1L, ahigh1L, aband1L svfilter a1L, kfiltFreq1, 1
  	alow1R, ahigh1R, aband1R svfilter a1R, kfiltFreq1, 1
  	alow2L, ahigh2L, aband2L svfilter a2L, kfiltFreq2, 1
  	alow2R, ahigh2R, aband2R svfilter a2R, kfiltFreq2, 1 
  	alow3L, ahigh3L, aband3L svfilter a3L, kfiltFreq3, 1
  	alow3R, ahigh3R, aband3R svfilter a3R, kfiltFreq3, 1 
  	alow4L, ahigh4L, aband4L svfilter a4L, kfiltFreq4, 1
  	alow4R, ahigh4R, aband4R svfilter a4R, kfiltFreq4, 1
  	alow5, ahigh5, aband5 svfilter a5, kfiltFreq5, 1
  	alow6, ahigh6, aband6 svfilter a6, kfiltFreq6, 1
  	alow7, ahigh7, aband7 svfilter a7, kfiltFreq7, 1 	
  	;alow5L, ahigh5L, aband5L svfilter a5L, kfiltFreq5, 1
  	;alow5R, ahigh5R, aband5R svfilter a5R, kfiltFreq5, 1  	
  	;alow6L, ahigh6L, aband6L svfilter a6L, kfiltFreq6, 1
  	;alow6R, ahigh6R, aband6R svfilter a6R, kfiltFreq6, 1  	
  	;alow7L, ahigh7L, aband7L svfilter a7L, kfiltFreq7, 1
  ;	alow7R, ahigh7R, aband7R svfilter a7R, kfiltFreq7, 1  	
  	;alow8L, ahigh8L, aband8L svfilter a8L, kfiltFreq8, 1
  	;alow8R, ahigh8R, aband8R svfilter a8R, kfiltFreq8, 1 
  	  	 
  	; put filters in array for controller selection and scale by klev value  	 
  	aFilt1L[0] = alow1L
  	aFilt1L[1] = ahigh1L
  	aFilt1R[0] = alow1R
  	aFilt1R[1] = ahigh1R
  	aFilt2L[0] = alow2L
  	aFilt2L[1] = ahigh2L
  	aFilt2R[0] = alow2R
  	aFilt2R[1] = ahigh2R
  	aFilt3L[0] = alow3L
  	aFilt3L[1] = ahigh3L
  	aFilt3R[0] = alow3R
  	aFilt3R[1] = ahigh3R
  	aFilt4L[0] = alow4L
  	aFilt4L[1] = ahigh4L
  	aFilt4R[0] = alow4R
  	aFilt4R[1] = ahigh4R
  	aFilt5[0] = alow5
  	aFilt5[1] = ahigh5 
  	aFilt6[0] = alow6
  	aFilt6[1] = ahigh6
  	aFilt7[0] = alow7
  	aFilt7[1] = ahigh7 	
  	;aFilt5L[0] = alow5L
  	;aFilt5L[1] = ahigh5L
  	;aFilt5R[0] = alow5R
  	;aFilt5R[1] = ahigh5R
  	;aFilt6L[0] = alow6L
  	;aFilt6L[1] = ahigh6L
  ;	aFilt6R[0] = alow6R
  	;aFilt6R[1] = ahigh6R
  	;aFilt7L[0] = alow7L
  	;aFilt7L[1] = ahigh7L
  	;aFilt7R[0] = alow7R
  	;aFilt7R[1] = ahigh7R
  	;aFilt8L[0] = alow8L
  	;aFilt8L[1] = ahigh8L
  	;aFilt8R[0] = alow8R
  	;aFilt8R[1] = ahigh8R
  	
 		
 		;;send filter out to delay opcode, returns on "adel..."
 		adel1L, adel1R pitchdelay aFilt1L[kfiltType1]*kdelsend1, aFilt1R[kfiltType1]*kdelsend1, gictrl_delay_time1, gictrl_fdbk1, gictrl_delayPShift1 
  	adel2L, adel2R pitchdelay aFilt2L[kfiltType2]*kdelsend2, aFilt2R[kfiltType2]*kdelsend2, gictrl_delay_time2, gictrl_fdbk2, gictrl_delayPShift2
  	adel3L, adel3R pitchdelay aFilt3L[kfiltType3]*kdelsend3, aFilt3R[kfiltType3]*kdelsend3, gictrl_delay_time3, gictrl_fdbk3, gictrl_delayPShift3
  	adel4L, adel4R pitchdelay aFilt4L[kfiltType4]*kdelsend4, aFilt4R[kfiltType4]*kdelsend4, gictrl_delay_time4, gictrl_fdbk4, gictrl_delayPShift4
  	adel5L, adel5R pitchdelay aFilt5[kfiltType5]*kdelsend5, aFilt5[kfiltType5]*kdelsend5, gictrl_delay_time5, gictrl_fdbk5, gictrl_delayPShift5
  	adel6L, adel6R pitchdelay aFilt6[kfiltType6]*kdelsend6, aFilt6[kfiltType6]*kdelsend6, gictrl_delay_time6, gictrl_fdbk6, gictrl_delayPShift6
  	adel7L, adel7R pitchdelay aFilt7[kfiltType7]*kdelsend7, aFilt7[kfiltType7]*kdelsend7, gictrl_delay_time7, gictrl_fdbk7, gictrl_delayPShift7
  
    ;;mix  delay and dry (post filter) sigs
  	asig1L = adel1L*kdelsend1 + aFilt1L[kfiltType1]*(1-kdelsend1)
  	asig1R = adel1R*kdelsend1 + aFilt1R[kfiltType1]*(1-kdelsend1)
  	asig2L = adel2L*kdelsend2 + aFilt2L[kfiltType2]*(1-kdelsend2)
  	asig2R = adel2R*kdelsend2 + aFilt2R[kfiltType2]*(1-kdelsend2)
  	asig3L = adel3L*kdelsend3 + aFilt3L[kfiltType3]*(1-kdelsend3)
  	asig3R = adel3R*kdelsend3 + aFilt3R[kfiltType3]*(1-kdelsend3)
  	asig4L = adel4L*kdelsend4 + aFilt4L[kfiltType4]*(1-kdelsend4)
  	asig4R = adel4R*kdelsend4 + aFilt4R[kfiltType4]*(1-kdelsend4)
  	asig5L = adel5L*kdelsend5 + aFilt5[kfiltType5]*(1-kdelsend5)
  	asig5R = adel5R*kdelsend5 + aFilt5[kfiltType5]*(1-kdelsend5)
  	asig6L = adel6L*kdelsend6 + aFilt6[kfiltType6]*(1-kdelsend6)
  	asig6R = adel6R*kdelsend6 + aFilt6[kfiltType6]*(1-kdelsend6)
  	asig7L = adel7L*kdelsend7 + aFilt7[kfiltType7]*(1-kdelsend7)
  	asig7R = adel7R*kdelsend7 + aFilt7[kfiltType7]*(1-kdelsend7)
  	
  	
  chnmix asig1L*kverbsend1, "verbmixL"
  chnmix asig1R*kverbsend1, "verbmixR"
  chnmix asig2L*kverbsend2, "verbmixL"
  chnmix asig2R*kverbsend2, "verbmixR"
  chnmix asig3L*kverbsend3, "verbmixL"
  chnmix asig3R*kverbsend3, "verbmixR"
  chnmix asig4L*kverbsend4, "verbmixL"
  chnmix asig4R*kverbsend4, "verbmixR"
  chnmix asig5L*kverbsend5, "verbmixL"
  chnmix asig5R*kverbsend5, "verbmixR"
  chnmix asig6L*kverbsend6, "verbmixL"
  chnmix asig6R*kverbsend6, "verbmixR"
  chnmix asig7L*kverbsend7, "verbmixL"
  chnmix asig7R*kverbsend7, "verbmixR"
  
  chnmix asig1L, "mixL"
  chnmix asig1R, "mixR"
  chnmix asig2L, "mixL"
  chnmix asig2R, "mixR"
  chnmix asig3L, "mixL"
  chnmix asig3R, "mixR"
  chnmix asig4L, "mixL"
  chnmix asig4R, "mixR"
  ;mix live signals
  chnmix asig5L, "mixL"
  chnmix asig5R, "mixR"
  chnmix asig6L, "mixL"
  chnmix asig6R, "mixR"
  chnmix asig7L, "mixL"
  chnmix asig7R, "mixR"
  
  ;;B-format encoding
  
  if giBEncode == 1 then
  	mixencoded asig1L, kalpha1, kbeta1
  	mixencoded asig1R, kalpha1, kbeta1
  	
  	mixencoded asig2L, kalpha2, kbeta2
  	mixencoded asig2R, kalpha2, kbeta2
  	
  	mixencoded asig3L, kalpha3, kbeta3
  	mixencoded asig3R, kalpha3, kbeta3
  	
  	mixencoded asig4L, kalpha4, kbeta4
  	mixencoded asig4R, kalpha4, kbeta4
  	
  	mixencoded asig5L, kalpha5, kbeta5
  	mixencoded asig5R, kalpha5, kbeta5
  	
  	mixencoded asig6L, kalpha6, kbeta6
  	mixencoded asig6R, kalpha6, kbeta6
  	
  	mixencoded asig7L, kalpha7, kbeta7
  	mixencoded asig7R, kalpha7, kbeta7
  	
  	
  	/*mixbformat:	
  		if ipos < giNSpeakers then
  			mixencoded asig1L, kalpha1, kbeta1, ipos
  			mixencoded asig1R, kalpha1, kbeta1, ipos
  	
  			mixencoded asig2L, kalpha2, kbeta2, ipos
  			mixencoded asig2R, kalpha2, kbeta2, ipos
  	
  			mixencoded asig3L, kalpha3, kbeta3, ipos
  			mixencoded asig3R, kalpha3, kbeta3, ipos		
  	
  			mixencoded asig4L, kalpha4, kbeta4, ipos
  			mixencoded asig4R, kalpha4, kbeta4, ipos
  	
  			mixencoded asig5L, kalpha5, kbeta5, ipos
  			mixencoded asig5R, kalpha5, kbeta5, ipos
  	
  			mixencoded asig6L, kalpha6, kbeta6, ipos
  			mixencoded asig6R, kalpha6, kbeta6, ipos
  	
  			mixencoded asig7L, kalpha7, kbeta7, ipos
  			mixencoded asig7R, kalpha7, kbeta7, ipos
  		ipos+=1
  		print ipos  		
  		goto mixbformat
  		
  		endif*/
 endif

endin

instr snapshotControl, 2

iprevPos = i(gkpos) ;remember previously selected snapshot
	
	; SNAPSHOT AND MORPHING SWITCHES
inote notnum
if inote != 0 then
	if gisnpset[inote]==0 && giselected[inote]==0 then		; go to snapshot 
			gksnapmode = 1
			gisnpset[inote] = 1
			giselected[inote] = 1
			gkpos = inote 	
			noteon gichan2, inote, 75
			if iprevPos != inote then
				giselected[iprevPos] = 0
				noteon gichan2, iprevPos, 60 ;turn prev selected snapshot to green
			endif
	elseif gisnpset[inote]==1 && giselected[inote]==0 then ; go to saved snapshot
			gksnapmode = 2
			giselected[inote]=1
			gkpos = inote
			noteon gichan2, inote, 75 ;red light
			if iprevPos != inote && gisnpset[iprevPos] == 1 then
				noteon gichan2, iprevPos, 60 ;green light
				giselected[iprevPos]=0
			endif
	elseif gisnpset[inote]==1 	&& giselected[inote]==1 then		; go to off state
			gisnpset[inote] = 0
			gksnapmode = 0
			giselected[inote] = 0
			gkpos = 0
			noteoff gichan2, inote, 0	
			prints "Reset Snapshot\n"	
	endif
endif

endin
	
instr inputRecordControl, 3 
	klfo lfo 1, 1, 3 ; square wave to modulate light
	inote notnum
	 	if inote != 0 then
			giactive = inote - 89 ;set offset from note for indexing arrays
			kRel release
			krecording init 0
			if inote = girec[giactive] && krecording == 0 then
			krecording = 1
			endif
		kchanged changed krecording
		if (kchanged == 1 && krecording == 1) then
	       giplayback[giactive] = 0				
	       event "i", 97, 0, 36000
						midion 3, girec[giactive], 75*klfo ; turn on recording light 
		endif	
		if changed(kRel) == 1 then
    turnoff2 97, 0, 1
    krecording = 0
    giplayback[giactive] = 1
    midion 3, girec[giactive], 127
		endif
	endif
	
endin

instr inputRecorder, 97
	prints "recording..."	
	gkLoopDuration[giactive]	line 0, 1, 1			; LOOP DURATION
	ain        inch     ginput               ; read audio from live input channel 1
	andx       line     0, gitablelength/sr, gitablelength  ; create an index for writing to table
           tablew   ain, andx, giRecBuf[giactive] ; write audio to function table
 	Sdate dates
	Sdir = "live_signals/"
	Sfilename strcat Sdir,Sdate
	Sfilename strcat  Sfilename, ".wav"  
	fout Sfilename, 24, ain; render file of input signal (if needed later)   

endin

instr reverb, 98
ainL chnget "verbmixL"
ainR chnget "verbmixR"
ain = ainL + ainR
aRevL, aRevR pconvolve ain, gSIRfile 
chnmix aRevL, "mixL"
chnmix aRevR, "mixR"
;outs aRevL, aRevR
endin

instr Mixer, 99

;initialize controller
noteoff 2, gistates[1], 0
noteoff 2, gistates[2], 0
noteoff 2, gistates[3], 0
noteoff 2, gistates[4], 0
noteoff 2, gistates[5], 0
noteoff 2, gistates[6], 0
noteoff 2, gistates[7], 0
noteoff 2, gistates[8], 0
noteoff 3, girec[0], 0 
noteoff 3, girec[1], 0 
noteoff 3, girec[2], 0 
noteoff 3, girec[3], 0 
noteoff 1, 108, 0

	amixL chnget "mixL"
	amixR chnget "mixR"
	kloopitch = 1
	idur = 10
	ifad = 5
	 
	
	;; if inote = 108 trigger instrument 100. on 2nd press turnoff
	inote notnum
	kRel release
	krecording init 0
	if inote = gictrl_record && krecording == 0 then
		krecording = 1
	endif
	kchanged changed krecording
	if (kchanged == 1 && krecording == 1) then
		event "i", 100, 0, 36000 
	endif
	if changed(kRel) == 1 then
    turnoff2 100, 0, 0
    midiout 128, gichan1, gictrl_record, 0 ;send note off blinking light
    krecording = 0
	endif
	
	outs amixL, amixR	
	chnclear "mixL"
	chnclear "mixR"
	chnclear "verbmixL"
	chnclear "verbmixR"
	
	

endin 
	
instr Render, 100
	allL, allR monitor
	klfo lfo 1, 1, 3 ; square wave to modulate light
	midion 1, 108, 127*klfo ; turn on recording light
	Sdate dates
	Sdir = "renders/"
	Sfilename strcat Sdir,Sdate
	Sfilename strcat  Sfilename, ".wav"  
	fout Sfilename, 24, allL, allR ; create 24-bit .wav file in specified directory
	
	if giBEncode == 1 then
	; bformat render 
	abform[] init giNSpeakers
	abform[0] = chnget:a("benc0")
	abform[1] = chnget:a("benc1")
	abform[2] = chnget:a("benc2")
	abform[3] = chnget:a("benc3")
	abform[4] = chnget:a("benc4")
	abform[5] = chnget:a("benc5")
	abform[6] = chnget:a("benc6")
	abform[7] = chnget:a("benc7")
	abform[8] = chnget:a("benc8")
	
	Sdir = "b_format/"
	Sfilename strcat Sdir,Sdate
	Sfilename strcat  Sfilename, ".wav"  
	fout Sfilename, 24, abform ; create 24-bit b-encoded file in specified directory 
	
	endif
	chnclear "benc0"
	chnclear "benc1"
	chnclear "benc2"
	chnclear "benc3"
	chnclear "benc4"
	chnclear "benc5"
	chnclear "benc6"
	chnclear "benc7"
	chnclear "benc8"
endin
</CsInstruments>
<CsScore>
;runs for 10 hours
i 1		0 	36000
i 2		0		36000
i 3		0		36000
i 98 	0		36000
i 99		0		36000  
e
 </CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>1510</x>
 <y>468</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject type="BSBButton" version="2">
  <objectName>button0</objectName>
  <x>43</x>
  <y>67</y>
  <width>100</width>
  <height>30</height>
  <uuid>{47824a64-9e54-4545-8631-e8a85f302609}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>button0</text>
  <image>/</image>
  <eventLine>i1 0 10</eventLine>
  <latch>false</latch>
  <latched>false</latched>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
