import java.util.*;
int i,j,k,f,w=250,C=1060;
Stack<float[]>l;
void setup(){
    size(2*w,2*w,P3D);
    stroke(w);
    float[][]p=new float[C][3];
    int[][]c=new int[C][C];
    l=new Stack<float[]>();

    for(;i<C*3;)p[i/3][i++%3]=random(w)-w/2;
        
    for(i=0;i<C;i++){
        int s[][]=new int[C][2];
        for(j=0;j<C;){
            for(k=0;k<3;){
              f=(int)(p[i][k]-p[j][k++]);
              s[j][0]+=f*f;
            }
            s[j][1]=j++;
        }
        java.util.Arrays.sort(s,new Comparator<int[]>(){
            public int compare(int[]a,int[]b){
                return a[0]-b[0];
            }
        });
        for(j=0;j<5;){
            k=(int)s[j++][1];
            if(c[i][k]<1){
                l.add(p[i]);
                l.add(p[k]);
            }
            c[i][k]=c[k][i]=1;
        }
    }
}
void draw(){
    clear();
    float t=(frameCount/30.f*1000.f)*5e-4;// millis()*5e-4;
    translate(w,w);
    rotateX(t);
    rotateY(t/3);
    rotate(t/4);
    beginShape(LINES);
    for(float[]v:l)vertex(v[0],v[1],v[2]);
    endShape();
//    saveFrame("#####.png");
    println(t);
}
