//Libraries
import processing.serial.*;
import controlP5.*;

//General objects
Serial myPort;
StopWatchTimer sw;
//Player one objects
ControlP5 cp5_one;
Knob myKnobA;
Slider Shoots_One_Slider;
//Player two ObjectsControlP5 cp5_one;
ControlP5 cp5_two;
Knob myKnobB;
Slider Shoots_Two_Slider;

//Serial store variable
int serialuniversalvalue = 0;

//Player one
//Player one knob Variables
int life_PO = 10;
int background_death_one = color(0, 160, 100);
//Slider player one variables Shoot
int sliderValue_ShootOne = 0;
//Special weapon Variables
String IROne_empty = "Yes";
String IROne_charged = "No";
String IROne_shotted = "No";
//Activation variables for player one
String flag_one = "No";
String activation_one = "No";

//Player two
//Player two knob Variables
int life_PT = 10;
int background_death_two = color(0, 160, 100);
//Slider player one variables Shoot
int sliderValue_ShootTwo = 0;
//Special weapon Variables
String IRTwo_empty = "Yes";
String IRTwo_charged = "No";
String IRTwo_shotted = "No";
//Activation variables for player two
String flag_two = "No";
String activation_two = "No";

//Watch Variables
int s = second();
int m = minute();
int h = hour();
String t;

//Timer variables
float a = 0;

//Objects for text and logo
PImage logo;
PFont title;
PFont life_title;//knob

void setup() {
        size(800,600);
        frameRate(120);
        //Setup font
        title = loadFont("Dialog-28.vlw");
        life_title = loadFont("Dialog-20.vlw");
        textFont(title);
        //Watch setup
        sw = new StopWatchTimer();
        sw.start();
        //New cp5_one Knob constructor for player one
        cp5_one = new ControlP5(this);
        myKnobA = cp5_one.addKnob("Life")
                  .setFont(life_title)
                  .setViewStyle(3)
                  .setRange(0,10)
                  .setValue(life_PO)
                  .setPosition(25,250)
                  .setRadius(120)
                  .hideTickMarks()
                  .setNumberOfTickMarks(20)
                  .setTickMarkLength(8)
                  .setTickMarkWeight(3)
                  .snapToTickMarks(true)
                  .setColorForeground(color(186,255,201,191))
                  .setColorBackground(background_death_one)
                  //.setColorActive(color(255,255,0))
                  .setDragDirection(Knob.VERTICAL)
        ;
        //New cp5_one Slider constructor
        Shoots_One_Slider = cp5_one.addSlider("Shoots")
                            .setFont(life_title)
                            .setRange(0,30)
                            //.setNumberOfTickMarks(10)
                            //.setColorTickMark(220)
                            .setValue(sliderValue_ShootOne)
                            .setPosition(285,240)
                            //Because is deprecated it only accept hex values
                            .setColorForeground(#0CB7F2)
                            .setColorValue(#FFFFFF)
                            .setColorLabel(#FFFFFF)
                            .setSize(40,250)
        ;
        //New cp5_two Knob constructor for player two
        cp5_two = new ControlP5(this);
        myKnobB = cp5_two.addKnob("Life")
                  .setFont(life_title)
                  .setViewStyle(3)
                  .setRange(0,10)
                  .setValue(life_PT)
                  .setPosition(430,250)
                  .setRadius(120)
                  .hideTickMarks()
                  .setNumberOfTickMarks(20)
                  .setTickMarkLength(8)
                  .setTickMarkWeight(3)
                  .snapToTickMarks(true)
                  .setColorForeground(color(186,255,201,191))
                  .setColorBackground(background_death_one)
                  //.setColorActive(color(255,255,0))
                  .setDragDirection(Knob.VERTICAL)
        ;
        //New cp5_two Slider constructor
        Shoots_Two_Slider = cp5_two.addSlider("Shoots")
                            .setFont(life_title)
                            .setRange(0,30)
                            //.setNumberOfTickMarks(10)
                            //.setColorTickMark(220)
                            .setValue(sliderValue_ShootTwo)
                            .setPosition(695,240)
                            //Because is deprecated it only accept hex values
                            .setColorForeground(#0CB7F2)
                            .setColorValue(#FFFFFF)
                            .setColorLabel(#FFFFFF)
                            .setSize(40,250)
        ;
        //Color of the background
        background(#B28DFF);
        //Open the port
        String portName = Serial.list()[5]; //change the 0 to a 1 or 2 etc. to match your port
        myPort = new Serial(this, portName, 115200);
        myPort.buffer(3);
}

void draw() {
        //Set the background of the game
        Game_BackGround();
        //Show the watch
        Watch();
        //Read the incoming data of the serial port
        Serial_Read_Data();
        if(flag_one == "Yes") {
                //Check for player one
                Serial_Event_PlayerOne();
                //Show events life for player one
                Player_One();
        } else {
                textFont(title);
                fill(#FFFFFF);
                text("Disconnected",55,210);
                noStroke();
                fill(255,35,1);
                ellipse(143,150,40,40);
        }
        if(flag_two == "Yes") {
                //Check for player two
                Serial_Event_PlayerTwo();
                //Show events life for player two
                Player_Two();
        } else {
                textFont(title);
                fill(#FFFFFF);
                text("Disconnected",460,210);
                noStroke();
                fill(255,35,1);
                ellipse(553,150,40,40);
        }

}

void Game_BackGround() {
        background(#B28DFF);
        //logo of laboratory
        logo = loadImage("Images/logo.png");
        image(logo, 20,20,248,75);
        //Title of the game
        fill(255);
        textFont(title);
        text("BlazerMuscle",335,40);
        //Name of the team
        fill(255);
        textFont(title);
        text("Team Roger One",305,90);
}

void Watch() {
        fill(255);
        textFont(title);
        text("TIMER",660,40);
        text(nf(sw.hour(), 2)+":"+nf(sw.minute(), 2)+":"+nf(sw.second(), 2),642,70);
}

void Serial_Read_Data() {
        if(myPort.available() > 0) {
                serialuniversalvalue = myPort.read(); // read it and store it in val
                if(activation_one == "No") {
                        println(serialuniversalvalue);
                        if(serialuniversalvalue == 79) {
                                flag_one = "Yes";
                                activation_one = "Yes";
                        }
                }
                if(activation_two == "No") {
                        println(serialuniversalvalue);
                        if(serialuniversalvalue == 84) {
                                flag_two = "Yes";
                                activation_two = "Yes";
                        }
                }
        }
}

void Serial_Event_PlayerOne(){
        //This is equal to one point because laser impact
        if(serialuniversalvalue == 1) {
                life_PO = life_PO - 1;
                myKnobA.setValue(life_PO);
                serialuniversalvalue = 0;
        }
        //This is equal to five points because IR impact
        if(serialuniversalvalue == 2) {
                life_PO = life_PO - 5;
                myKnobA.setValue(life_PO);
                serialuniversalvalue = 0;
        }
        //This will count 1 if the user shoot the laser gun
        if(serialuniversalvalue == 3) {
                sliderValue_ShootOne = sliderValue_ShootOne + 1;
                Shoots_One_Slider.setValue(sliderValue_ShootOne);
                serialuniversalvalue = 0;
        }
        //This will show if the special gun was charged
        if(serialuniversalvalue == 4) {
                IROne_empty = "No";
                IROne_charged = "Yes";
                serialuniversalvalue = 0;
        }
        //This will show if the special weapon was shotted
        if(serialuniversalvalue == 5) {
                IROne_charged = "No";
                IROne_shotted = "Yes";
                sliderValue_ShootOne = sliderValue_ShootOne + 1;
                Shoots_One_Slider.setValue(sliderValue_ShootOne);
                serialuniversalvalue = 0;
        }
}

void Player_One() {
        textFont(title);
        fill(#FFFFFF);
        text("Kishishita", 85, 210);
        //Generate the ellipse above the name
        if(life_PO > 5) {
                noStroke();
                fill(69,252,131);
                ellipse(143,150,40,40);
        }
        if((life_PO <= 5) && (life_PO > 0)) {
                //If the user end the game change the color to yellow
                noStroke();
                fill(255,247,77);
                ellipse(143,150,40,40);
                background_death_one = color(255,247,77);
                myKnobA.setColorForeground(#794DFF);
                myKnobA.setColorBackground(background_death_one);
                myKnobA.setColorValueLabel(#05A73F);
        }
        if (life_PO <= 0) {
                //If the user end the game change the color to red
                noStroke();
                fill(255,35,1);
                ellipse(143,150,40,40);
                background_death_one = color(255,35,1);
                myKnobA.setColorBackground(background_death_one);
                myKnobA.setColorValue(255);
        }
        if(IROne_empty == "Yes") {
                //Red indicate that the Special Weapon is not loaded
                noStroke();
                fill(0,112,184);
                ellipse(90,560,40,40);
                textFont(life_title);
                text("Special Weapon",122,567);
        }
        if(IROne_charged == "Yes") {
                noStroke();
                fill(#0F34FA);
                ellipse(90,560,40,40);
                textFont(life_title);
                text("Special Weapon Loaded",122,567);
        }
        if(IROne_shotted == "Yes") {
                IROne_shotted = "No";
                noStroke();
                fill(#12FA0F);
                rect(90,560,100,50);
                textFont(life_title);
                text("Special Weapon Shooted",122,567);
                IROne_empty = "Yes";
        }
}

void Serial_Event_PlayerTwo() {
  //This is equal to one point because laser impact
  if(serialuniversalvalue == 6) {
          life_PT = life_PT - 1;
          myKnobB.setValue(life_PT);
          serialuniversalvalue = 0;
  }
  //This is equal to five points because IR impact
  if(serialuniversalvalue == 7) {
          life_PT = life_PT - 5;
          myKnobB.setValue(life_PT);
          serialuniversalvalue = 0;
  }
  //This will count 1 if the user shoot the laser gun
  if(serialuniversalvalue == 8) {
          sliderValue_ShootTwo = sliderValue_ShootTwo + 1;
          Shoots_Two_Slider.setValue(sliderValue_ShootTwo);
          serialuniversalvalue = 0;
  }
  //This will show if the special gun was charged
  if(serialuniversalvalue == 9) {
          IRTwo_empty = "No";
          IRTwo_charged = "Yes";
          serialuniversalvalue = 0;
  }
  //This will show if the special weapon was shotted
  if(serialuniversalvalue == 10) {
          IRTwo_charged = "No";
          IRTwo_shotted = "Yes";
          sliderValue_ShootTwo = sliderValue_ShootTwo + 1;
          Shoots_Two_Slider.setValue(sliderValue_ShootTwo);
          serialuniversalvalue = 0;
  }
}

void Player_Two() {
  textFont(title);
  fill(#FFFFFF);
  text("Sue",528,210);
  //Generate the ellipse above the name
  if(life_PT > 5) {
          noStroke();
          fill(69,252,131);
          ellipse(553,150,40,40);
  }
  if((life_PT <= 5) && (life_PT > 0)) {
          //If the user end the game change the color to yellow
          noStroke();
          fill(255,247,77);
          ellipse(553,150,40,40);
          background_death_two = color(255,247,77);
          myKnobB.setColorForeground(#794DFF);
          myKnobB.setColorBackground(background_death_one);
          myKnobB.setColorValueLabel(#05A73F);
  }
  if (life_PT <= 0) {
          //If the user end the game change the color to red
          noStroke();
          fill(255,35,1);
          ellipse(553,150,40,40);
          background_death_two = color(255,35,1);
          myKnobB.setColorBackground(background_death_two);
          myKnobB.setColorValue(255);
  }
  if(IRTwo_empty == "Yes") {
          //Red indicate that the Special Weapon is not loaded
          noStroke();
          fill(0,112,184);
          ellipse(495,560,40,40);
          textFont(life_title);
          text("Special Weapon",527,567);
  }
  if(IRTwo_charged == "Yes") {
          noStroke();
          fill(#0F34FA);
          ellipse(495,560,40,40);
          textFont(life_title);
          text("Special Weapon Loaded",527,567);
  }
  if(IRTwo_shotted == "Yes") {
          IRTwo_shotted = "No";
          noStroke();
          fill(#12FA0F);
          rect(495,560,100,50);
          textFont(life_title);
          text("Special Weapon Shooted",527,567);
          IRTwo_empty = "Yes";
  }
}
