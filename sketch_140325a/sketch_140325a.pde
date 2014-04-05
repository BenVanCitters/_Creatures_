//import java.util.Comparator;int pC=2060;ArrayList<float[]>lnps;void setup(){
//size(displayWidth,displayHeight,P3D);stroke(255,50);strokeWeight(5);float[][]ps=new float[pC][3];int[][]cts=new int[pC][pC];lnps=new ArrayList<float[]>();for(int i=0;i<pC;i++)for(int j=0;j<3;j++)ps[i][j]=random(height)-height/2;for(int i=0;i<pC;i++){int clst[][]=new int[pC][2];for(int j=0;j<pC;j++){int d=0;for(int k=0;k<3;k++){int f=(int)(ps[i][k]-ps[j][k]);d+=f*f;}clst[j][0]=d;clst[j][1]=j;}java.util.Arrays.sort(clst,new Comparator<int[]>(){public int compare(int[]a,int[]b){return a[0]-b[0];}});for(int j=0;j<5;j++){int k = (int)clst[j][1];if(cts[i][k]<1){lnps.add(ps[i]);lnps.add(ps[k]);}cts[i][k]=cts[k][i]=1;}}}
//void draw(){
//background(0);
//float t=millis()/2000.f;
//translate(width/2,height/2);
////scale(1,sin(t/5),1);  
//rotateX(t);rotateY(t/3);rotateZ(t/4);beginShape(LINES);for(float[]p:lnps){vertex(p[0],p[1],p[2]);}endShape();}
