void setup() {
    //set resolution here
    size(9000,6000);

    //set background color here
    background(0,0,0);
    drawParticles();

    //set stroke color here
    stroke(0);

    strokeWeight(str_weight);
    loadColors();
}

ArrayList<Particle> p = new ArrayList<Particle>();
//set number of particles here, width/60 is a good number
int num = 150;
float noiseVal = 0.0009;
float noiseVal2 = 0.0005;

//enter colors here
color colors[] = {#00FFFF,#FF00FF,#FFFF00};
ArrayList<Integer> col_array = new ArrayList<Integer>();
float steps = 50;
//set stroke weight here higher stroke weight results in darker result
float str_weight = 1;


//loads colors from the colors array and generates a gradient palette
void loadColors(){
    
    for(int i = 0; i < steps/1.5;i++){
        col_array.add(color(colors[0]));
    }
    
    for(int i = 0; i < colors.length-1; i++){
        color from = colors[i];
        color to = colors[i+1];
        for(float j = 0; j < steps;j++){
            color c = lerpColor(from,to,j*(1/steps));
            col_array.add(color(c));
        }
    }
    print(color(255,255,0));
    for(float i = 0; i < steps/1.5;i++){
        col_array.add(color(colors[colors.length-1]));
    }
}


void draw() {
    //for each particle
    for(int i = 0; i < p.size(); i++){
        p.get(i).move();
        p.get(i).display();
        
        //remove particle from array if they move too far from canvas
        if(p.get(i).x > width + 1000 ||  p.get(i).x < -1000 || p.get(i).y > height+1000 || p.get(i).y < -1000){
            p.remove(i);
        }
        
        //saves final copy of canvas
        if(p.size() == 0){
            saveFrame("apf-final-######.png");
            exit();
        }
    }    
}

//takes screenshot on key press
void keyPressed() {
    saveFrame("apf-######.png");
}

//particle class
class Particle{
    float x;
    float y;
    float nx;
    float ny;
    Particle(float x,float y){
        this.x = x;
        this.y = y;
    }
    
    void display(){
        float h = map(this.nx,0,1,0,col_array.size());
        fill(col_array.get(floor(h)));
        ellipse(this.x,this.y,25,25);
    }
    
    void move(){
        this.nx = noise(this.x*noiseVal,this.y*noiseVal, frameCount*noiseVal);
        this.ny = noise(this.y*noiseVal2,this.x*noiseVal2, frameCount*noiseVal2);
        
        float nx = map(this.nx,0,1,-5,5);
        float ny = map(this.ny,0,1,-5,5);
        this.x += nx;
        this.y += ny;
    }
}

//loads particles into particle array
void drawParticles(){
    for(int i = -1; i <= num+1; i+= 1){
        for(int j = -1; j <= num+1; j+=1){
            p.add(new Particle(i*width/num,j*width/num));
        }
    }
}
