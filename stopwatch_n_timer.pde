// Clock
// Anas Uddin
// https://github.com/theanasuddin

import processing.sound.*;

PImage background;
PImage icon;
PImage audioOn;
PImage audioOnSemiGreen;
PImage audioOnFullGreen;

PImage audioOff;
PImage audioOffSemiGreen;
PImage audioOffFullGreen;

PImage stopwatch;
PImage stopwatchActive;
PImage stopwatchHover;
PImage timer;
PImage timerActive;
PImage timerHover;

PFont montserratExtraLight;
PFont montserratLight;
PFont montserratRegular;

float centerX;
float centerY;

color rectFill = color(120, 134, 169);
color semiGreen = color(0, 127, 0);
color quarterGreen = color(0, 100, 0);
color fullGreen = color(0, 255, 0);

int strokeWeightOne = 1;

boolean audioState = true;
boolean stopwatchState = false;
boolean timerState = false;
boolean audioHover;
boolean startStopHover;
boolean resetHover;

boolean timerStartStopHover;
boolean timerResetHover;

boolean stopwatchTab = true;
boolean timerTab = false;

boolean stopwatchTabHover;
boolean timerTabHover;

boolean timerHourDownHover;
boolean timerMinuteDownHover;
boolean timerSecondDownHover;

boolean timerHourUpHover;
boolean timerMinuteUpHover;
boolean timerSecondUpHover;

int stopwatchMiliSecond = 0;
int stopwatchSecond = 0;
int stopwatchMinute = 0;
int stopwatchHour = 0;
int stopwatchDay = 0;
int stopwatchYear = 0;
int stopwatchMonth = 0;

int dummyStopwatchMiliSecond = 0;
int dummyStopwatchSecond = 0;
int dummyStopwatchMinute = 0;
int dummyStopwatchHour = 0;
int dummyStopwatchDay = 0;
int dummyStopwatchYear = 0;
int dummyStopwatchMonth = 0;

int timerSecondToSubtruct = 1;

SoundFile soundOn;
SoundFile buttonClick;
SoundFile tabSwap;
SoundFile tick;

int arrowButtonPosX = 634;
int arrowButtonPosY = 490;
int arrowButtonXDifference = 150;

int timerHour = 0;
int timerMinute = 5;
int timerSecond = 0;

int newTimerHour = 0;
int newTimerMinute = 5;
int newTimerSecond = 0;

int prevTimerHour = 0;
int prevTimerMinute = 5;
int prevTimerSecond = 0;

int initialTimerTimeInSecond = (timerHour * 60 * 60) + (timerMinute * 60) + timerSecond;

void setup() {
  size(1620, 1080);
  frameRate(100);
  surface.setTitle("Stopwatch 'n Timer");
  icon = loadImage("icon.png");
  surface.setIcon(icon);
  background = loadImage("bg.jpg"); 
  audioOn = loadImage("audio_on.png"); 
  audioOnSemiGreen = loadImage("audio_on_semi_green.png"); 
  audioOnFullGreen = loadImage("audio_on_full_green.png"); 

  audioOff = loadImage("audio_off.png"); 
  audioOffSemiGreen = loadImage("audio_off_semi_green.png"); 
  audioOffFullGreen = loadImage("audio_off_full_green.png"); 

  stopwatch = loadImage("stopwatch.png"); 
  stopwatchActive = loadImage("stopwatch_active.png"); 
  stopwatchHover = loadImage("stopwatch_hover.png"); 
  timer = loadImage("timer.png"); 
  timerActive = loadImage("timer_active.png"); 
  timerHover = loadImage("timer_hover.png"); 

  montserratExtraLight = createFont("Montserrat-ExtraLight.otf", 32);
  montserratLight = createFont("Montserrat-Light.otf", 32);
  montserratRegular = createFont("Montserrat-Regular.otf", 192);

  soundOn = new SoundFile(this, "sound_on.mp3");
  buttonClick = new SoundFile(this, "button_click.mp3");
  tabSwap = new SoundFile(this, "tab_swap.mp3");
  tick = new SoundFile(this, "tick.mp3");

  centerX = width / 2;
  centerY = height / 2;
}

void draw() {
  image(background, 0, 0);

  setStroke(strokeWeightOne, rectFill);
  drawRect(246, 314, 1128, 453, rectFill, 63.75, 15);

  line(246.5, 386.5, 246.5 + 1127, 386.5);
  line(246.5, 694, 246.5 + 1127, 694);

  if (stopwatchState) {
    stopwatchMiliSecond++;
  }

  if (timerState) {
    if (frameCount % 100 == 99) {
      if (initialTimerTimeInSecond > 0) {
        initialTimerTimeInSecond = initialTimerTimeInSecond - timerSecondToSubtruct;

        newTimerSecond = initialTimerTimeInSecond % 60;
        newTimerMinute = initialTimerTimeInSecond / 60;
        newTimerHour = newTimerMinute / 60;
        newTimerMinute = newTimerMinute % 60;
      }
    }
  }

  if (initialTimerTimeInSecond == 0) {
    timerHour = 0;
    timerMinute = 0;
    timerSecond = 0;
    timerState = false;
  }

  if (stopwatchTab) {
    drawStopwatch();
    drawStartStopButton(255);
    drawResetButton(255);
  } else if (timerTab) {
    if (timerState) {
      drawTimer();
    }
    drawStartStopTimerButton(255);
    drawTimerResetButton(255);

    if (!timerState) {
      if (newTimerHour != prevTimerHour || newTimerMinute != prevTimerMinute || newTimerSecond != prevTimerSecond) {
        drawTimerChange();
      } else {
        drawTimer();
      }
    }
  }

  toggleMouse();

  if (frameCount % 100 == 99) {
    playTick();
  }

  if (timerTab) {
    for (int counter = 0; counter < 3; counter++) {
      drawTriangleUp(arrowButtonPosX, arrowButtonPosY, rectFill);
      drawTriangleDown(arrowButtonPosX, arrowButtonPosY + 100, rectFill);

      arrowButtonPosX = arrowButtonPosX + arrowButtonXDifference;
      arrowButtonPosY = 490;
    }
    arrowButtonPosX = 634;
  }
}

void drawRect(float posX, float posY, float rectWidth, float rectHeight, color rectFill, float alpha, float radii) {
  fill(rectFill, alpha);
  rect(posX, posY, rectWidth, rectHeight, radii);
}

void setStroke(float strokeWeight, color strokeColor) {
  stroke(strokeColor);
  strokeWeight(strokeWeight);
}

void toggleMouse() {
  if (audioState) {
    drawAudioButton(audioOn);
  } else {
    drawAudioButton(audioOff);
  }

  if (stopwatchTab) {
    drawStopwatchTab(stopwatchActive, fullGreen, fullGreen);
  } else {
    drawStopwatchTab(stopwatch, 255, rectFill);
  }

  if (timerTab) {
    drawTimerTab(timerActive, fullGreen, fullGreen);
  } else {
    drawTimerTab(timer, 255, rectFill);
  }

  if (mouseX >= 1324 && mouseX <= (1324 + 25) && mouseY >= 718 && mouseY <= (718 + 25)) {
    if (audioState) {
      drawAudioButton(audioOnSemiGreen);
    } else {
      drawAudioButton(audioOffSemiGreen);
    }

    audioHover = true;
    if (audioHover) {
      cursor(HAND);
    }
  } else if (mouseX >= 617 && mouseX <= (617 + 133) && mouseY >= 710 && mouseY <= (710 + 43)) {
    cursor(HAND);

    if (stopwatchTab) {
      drawStartStopButton(semiGreen);
      startStopHover = true;

      if (startStopHover) {
        cursor(HAND);
      }
    } else if (timerTab) {
      drawStartStopTimerButton(semiGreen);
      timerStartStopHover = true;

      if (timerStartStopHover) {
        cursor(HAND);
      }
    }
  } else if (mouseX >= 870 && mouseX <= (870 + 133) && mouseY >= 710 && mouseY <= (710 + 43)) {
    cursor(HAND);

    if (stopwatchTab) {
      drawResetButton(semiGreen);
      resetHover = true;

      if (resetHover) {
        cursor(HAND);
      }
    } else if (timerTab) {
      drawTimerResetButton(semiGreen);
      timerResetHover = true;

      if (timerResetHover) {
        cursor(HAND);
      }
    }
  } else if (mouseX >= 811 && mouseX <= (810 + 564) && mouseY >= 314 && mouseY <= (314 + 73) && !timerTabHover) {
    stopwatchTabHover = true;

    if (stopwatchTabHover && !stopwatchTab && !timerState) {
      cursor(HAND);
      drawStopwatchTab(stopwatchHover, semiGreen, semiGreen);
    }
  } else if (mouseX >= 246 && mouseX <= (246 + 563) && mouseY >= 314 && mouseY <= (314 + 73) && !stopwatchTabHover) {
    timerTabHover = true;

    if (timerTabHover && !timerTab && !stopwatchState) {
      cursor(HAND);
      drawTimerTab(timerHover, semiGreen, semiGreen);
    }
  } else if (mouseX >= 634 && mouseX <= (634 + 25) && mouseY >= 590 && mouseY <= (590 + 12.5)) {
    if (timerTab && !timerState) {
      drawTriangleDown(634, 590, semiGreen);
      timerHourDownHover = true;

      if (timerHourDownHover) {
        cursor(HAND);
      }
    }
  } else if (mouseX >= 784 && mouseX <= (784 + 25) && mouseY >= 590 && mouseY <= (590 + 12.5)) {
    if (timerTab && !timerState) {
      drawTriangleDown(784, 590, semiGreen);
      timerMinuteDownHover = true;

      if (timerMinuteDownHover) {
        cursor(HAND);
      }
    }
  } else if (mouseX >= 934 && mouseX <= (934 + 25) && mouseY >= 590 && mouseY <= (590 + 12.5)) {
    if (timerTab && !timerState) {
      drawTriangleDown(934, 590, semiGreen);
      timerSecondDownHover = true;

      if (timerSecondDownHover) {
        cursor(HAND);
      }
    }
  } else if (mouseX >= 634 && mouseX <= (634 + 25) && mouseY >= (490 - 12.5) && mouseY <= 490) {
    if (timerTab && !timerState) {
      drawTriangleUp(634, 490, semiGreen);
      timerHourUpHover = true;

      if (timerHourUpHover) {
        cursor(HAND);
      }
    }
  } else if (mouseX >= 784 && mouseX <= (784 + 25) && mouseY >= (490 - 12.5) && mouseY <= 490) {
    if (timerTab && !timerState) {
      drawTriangleUp(784, 490, semiGreen);
      timerMinuteUpHover = true;

      if (timerMinuteUpHover) {
        cursor(HAND);
      }
    }
  } else if (mouseX >= 934 && mouseX <= (934 + 25) && mouseY >= (490 - 12.5) && mouseY <= 490) {
    if (timerTab && !timerState) {
      drawTriangleUp(934, 490, semiGreen);
      timerSecondUpHover = true;

      if (timerSecondUpHover) {
        cursor(HAND);
      }
    }
  } else {
    cursor(ARROW);
    audioHover = false;

    if (stopwatchTab) {
      resetHover = false;
      startStopHover = false;
    }

    if (timerTab) {
      timerResetHover = false;
      timerStartStopHover = false;

      timerHourDownHover = false;
      timerMinuteDownHover = false;
      timerSecondDownHover = false;

      timerHourUpHover = false;
      timerMinuteUpHover = false;
      timerSecondUpHover = false;
    }

    stopwatchTabHover = false;
    timerTabHover = false;
  }
}

void toggleAudio() {
  if (audioState) {
    audioState = false;
    drawAudioButton(audioOffFullGreen);
  } else if (!audioState) {
    soundOn.play();
    audioState = true;
    drawAudioButton(audioOnFullGreen);
  }
}

void toggleStopwatch() {
  buttonClick.play();
  if (stopwatchState) {
    stopwatchState = false;
    drawStartStopButton(fullGreen);
  } else if (!stopwatchState) {
    stopwatchState = true;
    drawStartStopButton(fullGreen);
  }
}

void toggleTimer() {
  buttonClick.play();
  if (timerState) {
    timerState = false;
    drawStartStopTimerButton(fullGreen);
  } else if (!timerState) {
    timerState = true;
    drawStartStopTimerButton(fullGreen);
  }
}

void toggleTabs() {
  tabSwap.play();
  if (stopwatchTab) {
    stopwatchTab = false;
    timerTab = true;
  } else if (!stopwatchState) {
    stopwatchTab = true;
    timerTab = false;
  }
}

void resetStopwatch() {
  buttonClick.play();
  drawResetButton(fullGreen);
  if (!stopwatchState) {
    stopwatchMiliSecond = 0;
  }
}

void resetTimer() {
  buttonClick.play();
  drawTimerResetButton(fullGreen);

  if (!timerState) {
    initialTimerTimeInSecond = 300;

    newTimerHour = 0;
    newTimerMinute = 5;
    newTimerSecond = 0;

    prevTimerHour = 0;
    prevTimerMinute = 5;
    prevTimerSecond = 0;
  }
}

void mousePressed() {
  if (audioHover) {
    toggleAudio();
  }

  if (stopwatchTab) {
    if (startStopHover) {
      toggleStopwatch();
    }

    if (resetHover) {
      resetStopwatch();
    }
  }

  if (timerTab) {
    if (timerStartStopHover) {
      crossCheckTimerTime();
      toggleTimer();
    }

    if (timerResetHover) {
      resetTimer();
    }

    if (timerHourDownHover) {
      buttonClick.play();
      drawTriangleDown(634, 590, fullGreen);
      newTimerHour--;

      if (newTimerHour < 0) {
        newTimerHour = 99;
      }

      newTimerHour %= 100;
    }

    if (timerMinuteDownHover) {
      buttonClick.play();
      drawTriangleDown(784, 590, fullGreen);
      newTimerMinute--;

      if (newTimerMinute < 0) {
        newTimerMinute = 59;
      }

      newTimerMinute %= 60;
    }

    if (timerSecondDownHover) {
      buttonClick.play();
      drawTriangleDown(934, 590, fullGreen);
      newTimerSecond--;

      if (newTimerSecond < 0) {
        newTimerSecond = 59;
      }

      newTimerSecond %= 60;
    }

    if (timerHourUpHover) {
      buttonClick.play();
      drawTriangleUp(634, 490, fullGreen);
      newTimerHour++;
      newTimerHour %= 100;
    }

    if (timerMinuteUpHover) {
      buttonClick.play();
      drawTriangleUp(784, 490, fullGreen);
      newTimerMinute++;
      newTimerMinute %= 60;
    }

    if (timerSecondUpHover) {
      buttonClick.play();
      drawTriangleUp(934, 490, fullGreen);
      newTimerSecond++;
      newTimerSecond %= 60;
    }
  }

  if (timerTabHover && !timerTab && !stopwatchState) {
    toggleTabs();
  }

  if (stopwatchTabHover && !stopwatchTab && !timerState) {
    toggleTabs();
  }
}

void drawAudioButton(PImage image) {
  image(image, 1324, 718, 25, 25);
}

void drawStartStopButton(color rectFill) {
  drawRect(617, 710, 133, 43, rectFill, 63.75, 5);
  drawText(684, 731.5, 20, montserratLight, 255, getButtonText(stopwatchState));
}

void drawStartStopTimerButton(color rectFill) {
  setStroke(strokeWeightOne, color(120, 134, 169));
  drawRect(617, 710, 133, 43, rectFill, 63.75, 5);
  drawText(684, 731.5, 20, montserratLight, 255, getButtonText(timerState));
}

void drawText(float posX, float posY, int textSize, PFont textFont, color textFill, String text) {
  textAlign(CENTER, CENTER);
  textFont(textFont, textSize);
  fill(textFill);
  text(text, posX, posY);
}

void drawStopwatchText(float posX, float posY, int textSize, PFont textFont, color textFill, String text) {
  textAlign(CENTER, CENTER);
  textFont(textFont, textSize);
  fill(textFill);
  text(text, posX, posY);
}

void drawResetButton(color rectFill) {
  drawRect(870, 710, 133, 43, rectFill, 63.75, 5);
  drawText(937, 731.5, 20, montserratLight, 255, "RESET");
}

void drawTimerResetButton(color rectFill) {
  setStroke(strokeWeightOne, color(120, 134, 169));
  drawRect(870, 710, 133, 43, rectFill, 63.75, 5);
  drawText(937, 731.5, 20, montserratLight, 255, "RESET");
}

String getButtonText(boolean state) {
  if (initialTimerTimeInSecond == 0 && timerTab) {
    return "START";
  } else if (state) {
    return "STOP";
  } else {
    return "START";
  }
}

void drawImage(PImage image, float posX, float posY, int size) {
  image(image, posX, posY, size, size);
}

void drawStopwatchTab(PImage image, color textColor, color lineColor) {
  drawImage(image, 1013, 341, 20);
  drawText(1108, 351, 20, montserratLight, textColor, "STOPWATCH");

  setStroke(strokeWeightOne, lineColor);
  line(810.5, 386.5, 810.5 + 563, 386.5);
}

void drawTimerTab(PImage image, color textColor, color lineColor) {
  drawImage(image, 481, 341, 20);
  drawText(543, 351, 20, montserratLight, textColor, "TIMER");

  setStroke(strokeWeightOne, lineColor);
  line(246.5, 386.5, 246.5 + 563, 386.5);
}

void drawStopwatch() {
  dummyStopwatchMiliSecond = stopwatchMiliSecond % 100;

  stopwatchSecond = stopwatchMiliSecond / 100;
  dummyStopwatchSecond = stopwatchSecond % 60;

  stopwatchMinute = stopwatchSecond / 60;
  dummyStopwatchMinute = stopwatchMinute % 60;

  stopwatchHour = stopwatchMinute / 60;
  dummyStopwatchHour = stopwatchHour % 60;

  stopwatchDay = stopwatchHour / 24;
  dummyStopwatchDay = stopwatchDay % 24;

  stopwatchMonth = stopwatchDay / getNoOfDaysInCurrentMonth(month(), year());
  dummyStopwatchMonth = stopwatchMonth % 12;

  stopwatchYear = stopwatchMonth / 12;

  drawStopwatchText(358 + 26.5, centerY, 80, montserratRegular, 255, Integer.toString(stopwatchYear));
  drawStopwatchText(419 + 10.5, centerY + 20, 20, montserratRegular, 255, "y");

  drawStopwatchText(455 + 53, centerY, 80, montserratRegular, 255, nf(dummyStopwatchMonth, 2));
  drawStopwatchText(569 + 10.5, centerY + 20, 20, montserratRegular, 255, "m");

  drawStopwatchText(605 + 53, centerY, 80, montserratRegular, 255, nf(dummyStopwatchDay, 2));
  drawStopwatchText(719 + 10.5, centerY + 20, 20, montserratRegular, 255, "d");

  drawStopwatchText(755 + 53, centerY, 80, montserratRegular, 255, nf(dummyStopwatchHour, 2));
  drawStopwatchText(869 + 10.5, centerY + 20, 20, montserratRegular, 255, "h");

  drawStopwatchText(905 + 53, centerY, 80, montserratRegular, 255, nf(dummyStopwatchMinute, 2));
  drawStopwatchText(1019 + 10.5, centerY + 20, 20, montserratRegular, 255, "m");

  drawStopwatchText(1055 + 53, centerY, 80, montserratRegular, 255, nf(dummyStopwatchSecond, 2));
  drawStopwatchText(1169 + 10.5, centerY + 20, 20, montserratRegular, 255, "s");

  drawStopwatchText(1210 + 26.5, centerY + 15, 40, montserratRegular, 255, nf(dummyStopwatchMiliSecond, 2));
}


void drawTimer() {
  int timerSecond = initialTimerTimeInSecond % 60;
  int timerMinute = initialTimerTimeInSecond / 60;
  int timerHour = timerMinute / 60;
  timerMinute = timerMinute % 60;

  drawStopwatchText(593 + 53, centerY, 80, montserratRegular, 255, nf(timerHour, 2));
  drawStopwatchText(707 + 10.5, centerY + 20, 20, montserratRegular, 255, "h");

  drawStopwatchText(743 + 53, centerY, 80, montserratRegular, 255, nf(timerMinute, 2));
  drawStopwatchText(857 + 10.5, centerY + 20, 20, montserratRegular, 255, "m");

  drawStopwatchText(893 + 53, centerY, 80, montserratRegular, 255, nf(timerSecond, 2));
  drawStopwatchText(1007 + 10.5, centerY + 20, 20, montserratRegular, 255, "s");
}

void drawTimerChange() {
  drawStopwatchText(593 + 53, centerY, 80, montserratRegular, 255, nf(newTimerHour, 2));
  drawStopwatchText(707 + 10.5, centerY + 20, 20, montserratRegular, 255, "h");

  drawStopwatchText(743 + 53, centerY, 80, montserratRegular, 255, nf(newTimerMinute, 2));
  drawStopwatchText(857 + 10.5, centerY + 20, 20, montserratRegular, 255, "m");

  drawStopwatchText(893 + 53, centerY, 80, montserratRegular, 255, nf(newTimerSecond, 2));
  drawStopwatchText(1007 + 10.5, centerY + 20, 20, montserratRegular, 255, "s");
}

int getNoOfDaysInCurrentMonth(int currentMonth, int currentYear) {
  int noOfDays = 0;

  if (currentMonth == 1 || currentMonth == 3 ||currentMonth == 5 ||currentMonth == 7||currentMonth == 8||currentMonth == 10||currentMonth == 12) {
    noOfDays = 31;
  } else if (currentMonth == 4||currentMonth == 6||currentMonth == 9||currentMonth == 11) {
    noOfDays = 30;
  } else {
    if (currentMonth == 2) {
      if (currentYear % 400 == 0 && currentYear % 100 == 0) {
        noOfDays = 29;
      } else {
        if (currentYear % 4 == 0 && currentYear % 100 != 0) {
          noOfDays = 29;
        } else
          noOfDays = 28;
      }
    }
  }  
  return noOfDays;
}

void playTick() {
  if (audioState) {
    if (stopwatchState) {
      tick.play();
    } else if (timerState && initialTimerTimeInSecond != 0) {
      tick.play();
    }
  }
}

void drawTriangleDown(float posX, float posY, color fillColor) {
  setStroke(strokeWeightOne, rectFill);
  fill(fillColor, 63.75);
  triangle(posX, posY, posX+25, posY, posX + 12.5, posY + 12.5);
}

void drawTriangleUp(float posX, float posY, color fillColor) {
  setStroke(strokeWeightOne, rectFill);
  fill(fillColor, 63.75);
  triangle(posX, posY, posX+25, posY, posX + 12.5, posY - 12.5);
}

void crossCheckTimerTime() {
  if (newTimerHour != prevTimerHour || newTimerMinute != prevTimerMinute || newTimerSecond != prevTimerSecond) {
    prevTimerHour = newTimerHour;
    prevTimerMinute = newTimerMinute;
    prevTimerSecond = newTimerSecond;

    int newTimerTimeInSecond = (newTimerHour * 60 * 60) + (newTimerMinute * 60) + newTimerSecond;
    initialTimerTimeInSecond  = newTimerTimeInSecond;
  }
}
