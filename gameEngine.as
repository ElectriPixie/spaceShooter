/*
 * @author Pixie
 */
class Game {

  static var app : Game;

  function Game() {

    var explosionSound:Sound = new Sound();
    explosionSound.attachSound('explosionSound');
    var silenceSound:Sound = new Sound();
    silenceSound.attachSound('silence');
    silenceSound.start(0, 1000);
    var enemyBulletId:Number = 0;
    var count:Number = 0;
    var tmpSize:Number = 0;
    var explosionCount:Number = 0;
    var powerUpCount:Number = 0;
    var powerUpTrigger:Number = 288;
    var powerUpId:Number = 0;
    var powerUpLevel:Number = 1;
    var powerUpMaxLevel:Number = 5;
    var gameOver:Boolean = false;
    var enemyID:Number = 0;
    var stars:Number = 150;
    var starSpeedMax = 7;
    var starSpeedMin = 2;
    var spawnTime:Number = -310;
    var spawnLimit:Number = 20;
    var spawnTime2:Number = -1030;
    var spawnLimit2:Number = 36;
    var spawnTime3:Number = -720;
    var spawnLimit3:Number = 48;
    var spawnTime4:Number = 0;
    var spawnLimit4:Number = 12;
    var score:Number = 0;
    var cTime:Number = 0;
    var cLimit:Number = 6;
    var shipSpeed:Number = 10;
    var shootAllow:Boolean = false;

    var bgClip:MovieClip = _root.createEmptyMovieClip("bgClip", _root.getNextHighestDepth());

    var backGround:MovieClip = bgClip.attachMovie("backGround", "backGround", bgClip.getNextHighestDepth());

    var container:MovieClip = _root.createEmptyMovieClip("containter", _root.getNextHighestDepth());
 
    var enemyContainer:MovieClip = _root.createEmptyMovieClip("enemyContainer", _root.getNextHighestDepth());

    var bulletContainer:MovieClip = _root.createEmptyMovieClip("bulletContainer", _root.getNextHighestDepth());

    var enemyBulletContainer:MovieClip = _root.createEmptyMovieClip("enemyBulletContainer", _root.getNextHighestDepth());

    var startGameScreen:MovieClip = _root.attachMovie('startGameScreen', 'startGameScreen', _root.getNextHighestDepth());

    var gameOverScreen:MovieClip;
    var mcMain:MovieClip;

    var createPlayerShip:Function = function()
    {
      mcMain = container.attachMovie('mcMain', 'mcMain', container.getNextHigestDepth());
      mcMain._x = 380;
      mcMain._y = 500;
    }


    var shootBullet:Function = function(setX:Number, setY:Number, speedX:Number, speedY:Number)
    {
      var bulletID:Number = Math.random();
      bulletContainer.attachMovie('mcBullet', 'Bullet'+bulletID, bulletContainer.getNextHighestDepth());
      bulletContainer['Bullet'+bulletID]._x = setX;
      bulletContainer['Bullet'+bulletID]._y = setY;
      bulletContainer['Bullet'+bulletID].onEnterFrame = function()
      {
        if(gameOver)
        {
          this.removeMovieClip();
        }
        this._x += speedX;
        this._y += speedY;
        if(this._y < -1 * this._height || this._x < 0 || this._y > Stage.height || this._x > Stage.width)
        {
          this.removeMovieClip();
        }
      }
    }

    var createExplosion:Function = function(setX:Number, setY:Number, explosionSize:Number, numOfExplosions:Number)
    {
      var i:Number = 0;
      var noe:Number = numOfExplosions;
      while(i++ < noe)
      {
        tmpSize = 10 + random(14);
        container.attachMovie('explosion', 'explosion' + explosionCount, container.getNextHighestDepth());
        container['explosion' + explosionCount]._x = setX + random(explosionSize);
        container['explosion' + explosionCount]._y = setY + random(explosionSize);
        container['explosion' + explosionCount]._width = tmpSize;
        container['explosion' + explosionCount]._height = tmpSize;
        container['explosion' + explosionCount]._alpha = 50+random(50);
        container['explosion' + explosionCount].onEnterFrame = function()
        {
          this._width += 1;
          this._height += 1;
          this._alpha -= 5;
          if(this._alpha <= 0)
          {
            this.removeMovieClip();
          }
        }
        explosionCount++;
      }
    }

    var addPowerUp:Function = function()
    {
      container.attachMovie('powerUp', 'powerUp'+powerUpId, container.getNextHighestDepth());
      container['powerUp'+powerUpId]._x = int(Math.random() * (Stage.width - container['powerUp'+powerUpId]._width));
      container['powerUp'+powerUpId]._y = -60;
      container['powerUp'+powerUpId].onEnterFrame = function()
      {
        if(gameOver)
        {
          this.removeMovieClip();
        }else{
          this._y += 6;
          if(this.hitTest(mcMain))
          {
            this.removeMovieClip();
            if(powerUpLevel < powerUpMaxLevel)
            {
              powerUpLevel++;
            }
          }
          if(this._y > Stage.height)
          {
            this.removeMovieClip();
          }
        }
      }
      powerUpId++;
      powerUpCount = 0;
    }

    var moveStars:Function = function()
    {
      var j:Number = 0;
      while(j++ < stars)
      {
        var mc = bgClip['star'+j];
        if(mc._y < 600)
        {
          mc._y += mc.speed;
        }else{
          mc._y = 0;
          mc.speed = random(3) + 1;
          mc._x = random(800);
        }
      }
    }

    var initializeStars:Function = function()
    {
      for(var i = 0; i < stars; i++)
      {
        var mc:MovieClip = bgClip.attachMovie("star", "star"+i, bgClip.getNextHighestDepth());
        mc._x = random(800);
        mc._y = random(600);
        mc.speed = random(starSpeedMax - starSpeedMin) + starSpeedMin;
        var size:Number = random(2)+0.6*(random(4));
        mc._width = size;
        mc._height = size;
      }
    }

    var createEnemyShip:Function = function(enemyPoints:Number, shipName:String, setX:Number, setY:Number, speedX:Number, speedY:Number, hitPoints:Number)
    {
      enemyContainer.attachMovie(shipName, 'enemy'+enemyID, enemyContainer.getNextHighestDepth());
      enemyContainer['enemy'+enemyID]._x = int(Math.random() * Stage.width);

      enemyContainer['enemy'+enemyID]._x = setX;
      enemyContainer['enemy'+enemyID]._y = setY;
      enemyContainer['enemy'+enemyID].speedX = speedX;
      enemyContainer['enemy'+enemyID].speedY = speedY
      enemyContainer['enemy'+enemyID].alive = true
      enemyContainer['enemy'+enemyID].hp = hitPoints;
      enemyContainer['enemy'+enemyID].pointValue = enemyPoints;
      enemyContainer['enemy'+enemyID].shootCount = random(48);
      enemyContainer['enemy'+enemyID].onEnterFrame = function()
      {
        if(gameOver)
        {
          this.removeMovieClip();
        }
        this.shootCount++;
        this._y += this.speedY;
        this._x += this.speedX;
        if(this.shootCount >= 48)
        {
          enemyBulletContainer.attachMovie("enemyBullet", 'enemyBullet' + enemyBulletId, enemyBulletContainer.getNextHighestDepth());
          enemyBulletContainer['enemyBullet' + enemyBulletId]._x = this._x + 23;
          enemyBulletContainer['enemyBullet' + enemyBulletId]._y = this._y + 50;
          enemyBulletContainer['enemyBullet' + enemyBulletId].alive = true;
          enemyBulletContainer['enemyBullet' + enemyBulletId].onEnterFrame = function()
          {
            if(gameOver)
            {
              this.removeMovieClip();
            }
            this._y += 12;
            if(this._y >= Stage.height)
            {
              this.removeMovieClip();
              this.alive = false;
            }
            if(this.alive)
            {
              if(mcMain._y <= this._y+12 && mcMain._y+48 >= this._y)
              {
                if(mcMain._x <= this._x+12 && mcMain._x+48 >= this._x)
                {
                /* this is where you die you know, the place to hook for shields */
                  powerUpLevel--;
                  if(powerUpLevel <= 0)
                  {
                    gameOver = true; 
                    explosionSound.start();
                    createExplosion(mcMain._x, mcMain._y, 50, 24);
                    mcMain.removeMovieClip();
                    gameOverScreen = _root.attachMovie('gameOverScreen', 'gameOverScreen', _root.getNextHighestDepth());
                  }
                }
              } 
            }
          }
          enemyBulletId++;
          this.shootCount = 0;
        } 
        if(this._y > Stage.height)
        {
          this.removeMovieClip();
          this.alive = false;
        }
        if(this._x > Stage.width)
        {
          this.removeMovieClip();
          this.alive = false;
        }
        if(this._x < 0)
        {
          this.removeMovieClip();
          this.alive = false;
        }
        if(this.alive)
        {
          for(var cBullet:String in bulletContainer)
          {
            if(this.alive)
            {
              if(this._y+48 >= bulletContainer[cBullet]._y && this._y <= _root.bulletContainer[cBullet]._y+12)
              {
                if(this._x <= bulletContainer[cBullet]._x+12 && this._x+48 >= _root.bulletContainer[cBullet]._x)
                {
                this.hp--;
                bulletContainer[cBullet].removeMovieClip();
                if(this.hp <= 0)
                {
                  explosionSound.start();
                  createExplosion(this._x, this._y, 40, 12);
                  score += this.pointValue;
                  this.alive = false;
                  this.removeMovieClip();
                }
              }
            }
          }
        }
      }
      if(this.alive)
      {
        if(this._y >= container.mcMain._y - 30 && this._y <= container.mcMain._y)
        {
          if(this._x <= container.mcMain._x+30 && this._x >= container.mcMain._x -30)
          {
          /* this is the other place you die */
            powerUpLevel--;
            if(powerUpLevel <= 0)
            {
              explosionSound.start();
              createExplosion(mcMain._x, mcMain._y, 50, 24);
              mcMain.removeMovieClip();
              explosionSound.start();
              createExplosion(this._x, this._y, 40, 12);
              this.removeMovieClip();
              gameOverScreen = _root.attachMovie('gameOverScreen', 'gameOverScreen', _root.getNextHighestDepth());
              gameOver = true;
            }
          }
        }
      }
    }
    enemyID++;
  }

var startGame:Function = function()
{

  createPlayerShip();
  _root.createTextField("score", _root.getNextHighestDepth(), 0, 0, 100, 100);
  _root.score.text = "Score: 0";
  var scoreFormat:TextFormat = new TextFormat();
  scoreFormat.color = 0xFFFFFF;
  scoreFormat.size = 14;
  _root.score.setTextFormat(scoreFormat);

  container.onEnterFrame = function()
  {
  _root.score.text = "Score: "+score;
  _root.score.setTextFormat(scoreFormat);
  moveStars();
  if(gameOver)
  {
    if(Key.isDown(32))
    {
      gameOver = false;
      gameOverScreen.removeMovieClip();
      createPlayerShip(); 
      score = 0;
      powerUpLevel = 1;
      powerUpCount = 0;
      spawnTime = -310;
      spawnTime2 = -1030;
      spawnTime3 = -720;
      spawnTime4 = 0;
    }
  }else{
    powerUpCount++;
    spawnTime++;
    spawnTime2++;
    spawnTime3++;
    spawnTime4++;
    cTime++;
    if(powerUpCount == powerUpTrigger)
    {
      addPowerUp();
    }

    if(spawnTime == spawnLimit)
    {
      createEnemyShip(100, 'enemyShip', random(Stage.width-48), -48, 0, 8, 2);
      spawnTime = 0;
    }

    if(spawnTime2 == spawnLimit2)
    {
      createEnemyShip(300, 'enemyShip2', random(Stage.width-64), -64, 0, 4, 6);
      spawnTime2 = 0;
    }

    if(spawnTime3 == spawnLimit3)
    {
      if(random(2))
      {
        createEnemyShip(200, 'enemyShip3', 0, -48, (random(5)+2), (random(5)+4), 4);
      }else{
        createEnemyShip(200, 'enemyShip3', Stage.width-48, -48, -(random(5)+2), (random(5)+4), 4);
    }
    spawnTime3 = 0;
  }
  if(spawnTime4 == spawnLimit4)
  {
    createEnemyShip(100, 'enemyShip4', random(Stage.width - 48), -48, 0, 6, 1);
    spawnTime4 = 0;
  }
  if(cTime == cLimit)
  {
    shootAllow = true;
    cTime = 0;
  }
  if(Key.isDown(37))
  {
    mcMain._x -= shipSpeed;
  }
  if(Key.isDown(38))
  {
    mcMain._y -= shipSpeed;
  }
  if(Key.isDown(39))
  {
    mcMain._x += shipSpeed;
  }
  if(Key.isDown(40))
  {
    mcMain._y += shipSpeed;
  }
  if(mcMain._x <= 3)
  {
    mcMain._x += shipSpeed;
  }
  if(mcMain._y <= 0)
  {
    mcMain._y += shipSpeed;
  }
  if(mcMain._x >= Stage.width - mcMain._width)
  {
    mcMain._x -= shipSpeed;
  }
  if(mcMain._y >= Stage.height - mcMain._height)
  {
    mcMain._y -= shipSpeed;
  }
  if(Key.isDown(17) && shootAllow)
  {
    shootAllow = false;
    cTime = 0;
  
    if(powerUpLevel == 1)
    {
      shootBullet((mcMain._x + mcMain._width/2 - 6), (mcMain._y - 12), 0, -14);
    }
  
    if(powerUpLevel == 2)
    {
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y -12), 0, -14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y -12), 0, -14);
    }

    if(powerUpLevel == 3)
    {
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y -12), 0, -14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y -12), 0, -14);
      shootBullet((mcMain._x + mcMain._width/2 -6), (mcMain._y +48), 0, 14);
    }

    if(powerUpLevel == 4)
    {
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y -12), 0, -14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y -12), 0, -14);
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y -12), -14, -14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y -12), 14, -14);
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y +48), 0, 14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y +48), 0, 14);
    }

    if(powerUpLevel == 5)
    {
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y -12), 0, -14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y -12), 0, -14);
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y -12), -14, -14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y -12), 14, -14);
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y +48), 0, 14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y +48), 0, 14);
      shootBullet((mcMain._x + mcMain._width/2), (mcMain._y +48), -14, 14);
      shootBullet((mcMain._x + mcMain._width/2 -12), (mcMain._y +48), 14, 14);
    }
  }

  }

  }

  }
    initializeStars();
    startGameScreen.onEnterFrame = function()
    {
      moveStars();
    }
    startGameScreen.onPress = function()
    {
      startGameScreen.removeMovieClip();
      startGame();
    }
  }

  /* entry point */
  static function main(mc) 
  {
    app = new Game();
  }
}
 
