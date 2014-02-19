#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	
	camWidth 		= 1280;	// try to grab at this size.
	camHeight 		= 720;
	
    //we can now get back a list of devices. 
	vector<ofVideoDevice> devices = vidGrabber.listDevices();
	
    for(int i = 0; i < devices.size(); i++){
		cout << devices[i].id << ": " << devices[i].deviceName; 
        if( devices[i].bAvailable ){
            cout << endl;
        }else{
            cout << " - unavailable " << endl; 
        }
	}
    
    
    for(int i = 0; i < LINE_COUNT; i++)
    {
        mMesh[i].setMode(OF_PRIMITIVE_LINE_STRIP);
        mMesh[i].setUsage(GL_DYNAMIC_DRAW);
        for(int j = 0; j < SEG_COUNT; j++)
        {
            mMesh[i].addVertex(ofVec2f(j*ofGetWidth()/(SEG_COUNT-1.f),
                                       i*ofGetHeight()/(LINE_COUNT-1.f) + ofRandom(4)-2));
        }
	}
    vidGrabber.setDeviceID(0);
	vidGrabber.setDesiredFrameRate(60);
	vidGrabber.initGrabber(camWidth,camHeight);
	
	videoInverted 	= new unsigned char[camWidth*camHeight*3];
	videoTexture.allocate(camWidth,camHeight, GL_RGB);	
	ofSetVerticalSync(true);
}


//--------------------------------------------------------------
void testApp::update()
{
	vidGrabber.update();
	float tm = ofGetElapsedTimef();
	if (vidGrabber.isFrameNew()){
		//int totalPixels = camWidth*camHeight*3;
		
        unsigned char * pixels = vidGrabber.getPixels();
        float mouseAmt = ofGetMouseX()*1.f/ofGetWindowWidth();
        float lineMaxAmp = 6.f;
        float maxLineFreq = 12.f/5.f;
        for(int i = 0; i < LINE_COUNT; i++)
        {
            int colorIndex = i % 3;
            float tVal = 0.f;
            for(int j = 0; j < SEG_COUNT; j++)
            {
                float xNorm = j*1.f/(SEG_COUNT);
                float yNorm = i*1.f/(LINE_COUNT);
                int camIndex = (int)((int)(yNorm*camHeight+1) *camWidth*3 - xNorm*camWidth*3);
                float brightnessNorm = pixels[camIndex+colorIndex]/255.f;//(pixels[camIndex]+pixels[camIndex+1]+pixels[camIndex+2])/(255.f*3.f);
                tVal += brightnessNorm*maxLineFreq;
                mMesh[i].setVertex(j, ofVec2f(j*ofGetWidth()/(SEG_COUNT-1.f),
                                              i*ofGetHeight()/(LINE_COUNT-1.f) +lineMaxAmp*sin(tm+tVal)));
            }
        }
        
//		for (int i = 0; i < totalPixels; i++){
//			videoInverted[i] = 255 - pixels[i];
//		}
//		videoTexture.loadData(videoInverted, camWidth,camHeight, GL_RGB);
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	ofBackground(0,0,0);
	ofSetHexColor(0xffffff);
    ofSetLineWidth(.5);
//	vidGrabber.draw(0,0);
	//videoTexture.draw(20+camWidth,20,camWidth,camHeight);
//    ofTranslate(0,0,-200);
    for(int i = 0; i < LINE_COUNT; i++)
    {
        int colorIndex = i % 3;
        switch (colorIndex) {
            case 0:
                ofSetColor(255,0,0,200);
                break;
            case 1:
                ofSetColor(0,255,0,200);
                break;
            case 2:
                ofSetColor(0,0,255,200);
                break;
                
            default:
                break;
        }
        mMesh[i].draw();
    }
    
}


//--------------------------------------------------------------
void testApp::keyPressed  (int key){ 
	
	// in fullscreen mode, on a pc at least, the 
	// first time video settings the come up
	// they come up *under* the fullscreen window
	// use alt-tab to navigate to the settings
	// window. we are working on a fix for this...
	
	// Video settings no longer works in 10.7
	// You'll need to compile with the 10.6 SDK for this
    // For Xcode 4.4 and greater, see this forum post on instructions on installing the SDK
    // http://forum.openframeworks.cc/index.php?topic=10343        
	if (key == 's' || key == 'S'){
		vidGrabber.videoSettings();
	}
	
	
}

//--------------------------------------------------------------
void testApp::keyReleased(int key){ 
	
}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y ){
	
}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){
	
}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){
	
}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ 

}
