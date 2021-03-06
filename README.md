# Shaking Icon Flutter widget

##  Add a shaking icon to your Flutter app.

Icon to shake - This can be either an IconData object <br/>
or a String assetName for an AssetImage.
```
final dynamic icon;
```
Size parameter passed to Icon constructor<br/>
Default is 36
```
final double size;
```
Function to determine shake flag from outside this class<br/>
This function takes precedence over shake flag
```
final Function shakeIt;
```
Enable / Disable shake flag to support dynamic UI.<br/>
Default value is true
```
final bool shake;
```
Color parameter passed to Icon constructor
```
final Color color;
```
Horizontal shake.<br/>
Default to Horizontal shake
```
final bool horizontalShake;
```
Diagonal shake if horizontalShake && verticalShake = true<br/>
Vertical shake.<br/>
Default to Horizontal shake
```
final bool verticalShake;
```
Frequency to repeat the shake in seconds
```
final int secondsToRepeat;
```
Example usages:
``` dart
ShakingIcon(Icons.verified_user, size: 32, 
    shakeIt: (bool shake) {
              if(shake) return true;
              else return false;
    },
)

ShakingIcon('assets/003-pointer.png', color: Colors.black, horizontalShake: false, shake: false)
  
```
