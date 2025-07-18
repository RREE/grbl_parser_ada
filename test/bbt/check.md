### Scenario : simple OK

 - When I run `./bin/test_cl -l ok`
 - then I get no error 
 - and I get `ok`

### Scenario : Alarm 3
 - When I run `./bin/test_cl -l ALARM:3`
 - then I get no error 
 - and I get `Alarm received, Abort Cycle`


### Scenario : Alarm 1
 - When I run `./bin/test_cl -l ALARM:1`
 - then I get no error 
 - and I get `Alarm received, Hard Limit`

 
## Maschine coordinates

### Scenario : one axis X
 - When I run `./bin/test_cl -l <Idle|MPos:10.000|FS:0,0>`
 - then I get no error 
 - and the output contains `System is in state 'Idle'`
 

### Scenario : two axes XY
 - When I run `./bin/test_cl -l <Idle|MPos:10.000,0.000|FS:0,0>`
 - then I get no error 
 - and the output contains `System is in state 'Idle'`
 - and the output contains `Pos X:  1.00000E+01`
 - and the output contains `Pos Y:  0.00000E+00`
 * and the output does not contain `Pos Z:`
 - and the output contains `Feedrate: 0`

### Scenario : three axes XYZ
 - When I run `./bin/test_cl -l <Idle|MPos:10.000,0.000,0.000|FS:0,0>`
 - then I get no error 
 - and the output contains `System is in state 'Idle'`
 - and the output contains `Pos X:  1.00000E+01`
 - and the output contains `Pos Z:  0.00000E+00`

### Scenario : four axes XYZA
 - When I run `./bin/test_cl -l <Idle|MPos:10.000,0.000,0.000,0.000|FS:0,0>`
 - then I get no error 
 - and the output contains `System is in state 'Idle'`
 - and the output contains `Pos X:  1.00000E+01`
 - and the output contains `Pos A:  0.00000E+00`


### Scenario: Some sample lines
 - When I run `./bin/test_cl -l <Run|MPos:0.000,0.000,0.000|Bf:15,128|FS:0,1000|Ov:100,100,100|A:SF>`
 - then I get no error 
 - and the output contains `System is in state 'Run'`


