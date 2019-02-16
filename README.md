# Podan - Podium Animations In Sketchup Helper

## This extension is VERY RISKY; it can easily run off the rails.
The techniques used do not have official support from Sketchup and Podium. Crashes, freezes, hangs, file system pollution/corruption, computer overheating/death, and data loss can occur. DON'T USE THIS EXTENSION if you are not computer savvy and can't live with these risks occurring.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## What does this Extension try to do?
It goes through your entire animation frame by frame at 24fps and calls Podium on each animating frame. It has some smarts to just copy previous frames if the scene is not yet animating to another scene. It tries to avoid known issues by attempting to monitor when Podium is done and only allowing one run at a time. So it is slow.

## How to setup it up
There are a lot of things you have to get exactly right for this to even have a chance of working for you:

Do not try to use on anything with more than 99999 frames; 1.15 hours.
If you want to limit running/rerunning to only a subset of scenes, I recommend you make a copy of your Sketchup design and delete the scenes you don't want before running this. There is no native subset support in this extension.
Make sure Podium is in "png" image write type in Podium setup.
Note/create/set Podium file write directory in Podium setup.
Make sure that location has no existing podan_*.png files.
Go to Extensions -> "Run/Cancel Podan".
Make sure you got the same Podium file write directory location in the Extension GUI. You must specify the full Windows path, something like:
```
C:\Users\JohnDoe\Desktop\podan_renderings
```
Expect a minute delay before anything happens.
Do not try to run other Podium jobs while this is running.
Do not try to work in Sketchup while this is running.
To CANCEL a current run, go to Extensions -> "Run/Cancel Podan" again and it will prompt you to cancel the current run. WAIT at least 2 minutes for it to really cancel already scheduled internal tasks. In Podium, cancel any current rendering operations. Remember to erase any existing podan_*.png files before rerunning.

## Post processing
I used kdenlive to turn the clips into an mp4. I applied the "denoiser" effect to reduce the shadow "butterfly effect" (a small change in camera causing a disproportionate change in how shadows look).
