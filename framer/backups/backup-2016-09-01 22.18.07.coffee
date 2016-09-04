# Made with Framer
# by Todd Hamilton
# www.toddham.com

currScene = 0
lastScene = 0
# timestamps of scene starts in seconds
sceneStarts = [0, 46, 67.9, 87,108,151,181.7,215,256.5,279,305.5,321.75,340.75,361.9,392.75,409.75,432.75,453.5,
472.2,485.75,506.8,526,555.4,588.75,616,1000]
# choice button coords [button 1: [[xMin, xMax], [yMin, yMax]],...]
normalChooseCoords = [[[93, 325], [333, 400]], [[416, 656], [337, 400]]]
tallChooseCoords = [[[94, 325], [318, 433]], [[418, 651], [315, 436]]]
naChooseCoords = [[[-1, -1], [-1, -1]], [[-1, -1], [-1, -1]]]
# choose button coords for all scenes
chooseCoords = [
	normalChooseCoords,
	tallChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	tallChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	tallChooseCoords,
	normalChooseCoords,
	tallChooseCoords,
	normalChooseCoords,
	normalChooseCoords,
	naChooseCoords
]
# nextStepScenes [[leftScene, rightScene], ...]


#time given for the choice in seconds
choiceTimer = 10

# setup a container to hold everything
videoContainer = new Layer
	width:640
	height:360
	backgroundColor:'#fff'
	shadowBlur:2
	shadowColor:'rgba(0,0,0,0.24)'

# create the video layer
videoLayer = new VideoLayer
	width: 640
	height: 360
	video: "images/morning.mp4"
	superLayer: videoContainer

# center everything on screen	
videoContainer.center()

# when the video is clicked
videoLayer.on Events.Click, ->
	# check if the player is paused
	if videoLayer.player.paused == true
		# if true call the play method on the video layer
		videoLayer.player.play()
		playButton.image = 'images/pause.png'
	else
		# else pause the video
		videoLayer.player.pause()
		playButton.image = 'images/play.png'
		
	# simple bounce effect on click	
	playButton.scale = 1.15
	playButton.animate
		properties:
			scale:1
		time:0.1	
		curve:'spring(900,30,0)'
		
# control bar to hold buttons and timeline
controlBar = new Layer
	width:videoLayer.width - 448
	height:48		
	backgroundColor:'rgba(0,0,0,0.75)'	
	clip:false
	borderRadius:'8px'
	superLayer:videoContainer

# center the control bar
controlBar.center()

# position control bar towards the bottom of the video
controlBar.y = videoLayer.maxY - controlBar.height - 10

# play button
playButton = new Layer
	width:48
	height:48
	image:'images/play.png'
	superLayer:controlBar
	
# on/off volume button
volumeButton = new Layer
	width:48
	height:48
	image:'images/volume_on.png'
	superLayer:controlBar

# position the volume button to the right of play
volumeButton.x = playButton.maxX

# back-scene layer
backButton = new Layer
	width:48
	height:48
	image:'images/back.png'
	superLayer:controlBar
	
# position back-scene button to the right of play
backButton.x = volumeButton.maxX

# skip to choice button
skipToChoiceButton = new Layer
	width:48
	height:48
	image:'images/choose.png'
	superLayer:controlBar
	
# position back-scene button to the right of play
skipToChoiceButton.x = backButton.maxX

# forward-scene layer
forwardScene = new Layer
	width: 640
	height: 300
	video: "images/morning.mp4"
	superLayer: videoContainer
	backgroundColor: ""

# Function to handle play/pause button
playButton.on Events.Click, ->
	if videoLayer.player.paused == true
		videoLayer.player.play()
		playButton.image = "images/pause.png"
	else
		videoLayer.player.pause()
		playButton.image = "images/play.png"
		
	# simple bounce effect on click	
	playButton.scale = 1.15
	playButton.animate
		properties:
			scale:1
		time:0.1	
		curve:'spring(900,30,0)'	

# helper function for figuring out if a scene choose button is being pressed
sceneChooseButtonChecker = (xCoord, yCoord) -> 
	chooseLeft = chooseCoords[currScene][0]
	chooseRight = chooseCoords[currScene][1]
	chooseLeftX = chooseLeft[0]
	chooseLeftY = chooseLeft[1]
	chooseRightX = chooseRight[0]
	chooseRightY = chooseRight[1]
	if xCoord >= chooseLeftX[0] and xCoord <= chooseLeftX[1] and yCoord >= chooseLeftY[0] and yCoord <= chooseLeftY[1]
		print "pressed left"
		#videoLayer.player.fastSeek(sceneStarts[currScene + 1] - 10)
	else if xCoord >= chooseRightX[0] and xCoord <= chooseRightX[1] and yCoord >= chooseRightY[0] and yCoord <= chooseRightY[1]
		print "pressed right"

		
# Function to handle forward scene choice
forwardScene.on Events.Tap, (event) ->
	xCoord = event.point.x
	yCoord = event.point.y
	print event.point
	sceneChooseButtonChecker(xCoord, yCoord)
	#print event.point
	#if xCoord > 93 and xCoord < 326 and yCoord > 359 and yCoord < 421
#		print "CHOICE A"
#	else if xCoord > 419 and xCoord < 649 and yCoord > 360 and yCoord < 422
#		print "CHOICE B"
	#print event.point.x

# Volume on/off toggle
volumeButton.on Events.Click, ->
	if videoLayer.player.muted == false
  		videoLayer.player.muted = true
  		volumeButton.image = "images/volume_off.png"
	else
		videoLayer.player.muted = false
		volumeButton.image = "images/volume_on.png"
		
	# simple bounce effect on click	
	volumeButton.scale = 1.15
	volumeButton.animate
		properties:
			scale:1
		time:0.1	
		curve:'spring(900,30,0)'
		
# Function to handle back button
backButton.on Events.Click, ->
	videoLayer.player.fastSeek(sceneStarts[lastScene])
	
	# simple bounce effect on click
	backButton.scale = 1.15
	backButton.animate
		properties:
			scale:1
		time:0.1	
		curve:'spring(900,30,0)'

# Function to handle choose button
skipToChoiceButton.on Events.Click, ->
	videoLayer.player.fastSeek(sceneStarts[currScene + 1] - 10)
	
	# simple bounce effect on click
	skipToChoiceButton.scale = 1.15
	skipToChoiceButton.animate
		properties:
			scale:1
		time:0.1	
		curve:'spring(900,30,0)'
		
# white timeline bar
timeline = new Layer
	width:455
	height:10
	y:backButton.midY - 5
	x:backButton.maxX + 10
	borderRadius:'10px'
	backgroundColor:'#fff'
	clip:false
	#superLayer: controlBar

# progress bar to indicate elapsed time
progress = new Layer
	width:0
	height:timeline.height
	borderRadius:'10px'
	backgroundColor:'#03A9F4'
	superLayer: timeline

# scrubber to change current time
scrubber = new Layer
	width:18
	height:18
	y:-4
	borderRadius:'50%'
	backgroundColor:'#fff'
	shadowBlur:10
	shadowColor:'rgba(0,0,0,0.75)'
	superLayer: timeline

# make scrubber draggable
scrubber.draggable.enabled = true

# limit dragging along x-axis	
scrubber.draggable.speedY = 0

# prevent scrubber from dragging outside of timeline
scrubber.draggable.constraints =
	x:0
	y:timeline.midY
	width:timeline.width
	height:-10		
	
# Disable dragging beyond constraints 
scrubber.draggable.overdrag = false

# helper function for scene transitions
sceneUpdate = (currTime, targetScene) -> 
	if sceneStarts[targetScene] < currTime and currTime <= sceneStarts[targetScene+1] and currScene != targetScene
		lastScene = currScene
		currScene = targetScene
		print "lastScene: ", lastScene
		print "currScene: ", currScene
	
# Update the progress bar and scrubber AND CURR/LAST SCENE as video plays
videoLayer.player.addEventListener "timeupdate", ->
	# Calculate progress bar position
	newPos = (timeline.width / videoLayer.player.duration) * videoLayer.player.currentTime
	
	# Update progress bar and scrubber
	scrubber.x = newPos
	progress.width = newPos	+ 10

	# Update curr and last scene if scene has just switched
	currTime = videoLayer.player.currentTime
	sceneUpdate(currTime, scene) for scene in [0..sceneStarts.length]
		
# Pause the video at start of drag
scrubber.on Events.DragStart, ->
	videoLayer.player.pause()

# Update Video Layer to current frame when scrubber is moved
scrubber.on Events.DragMove, ->
	progress.width = scrubber.x + 10

# When finished dragging set currentTime and play video
scrubber.on Events.DragEnd, ->
	newTime = Utils.round(videoLayer.player.duration * (scrubber.x / timeline.width),0);
	videoLayer.player.currentTime = newTime
	videoLayer.player.play()
	playButton.image = "images/pause.png"
		