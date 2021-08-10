// ActionScript Document
//MENU DO CANTO
_root.attachMovie("inventario", "inventario", 10);
setProperty("inventario", _x, 800);
setProperty("inventario", _y, 600);
fscommand("fullscreen",true);
fscommand("showmenu",false);

//Objeto Jogador
jogador.nome = "Francisco";
jogador.saude = 50;
jogador.dinheiro = 00;
jogador.forca = 25;
jogador.defesa = 5;
jogador.armamento = "madeira";
jogador.missao = "Acumular 30 reais, que estão espalhados pela casa, você já tem " + jogador.dinheiro + " de R$30 necessários";

//VARIÁVEIS
numeroDeRecuadoDoJogador = 6;
numeroDeExpelidaDoJogador = 5;
menu._visible = false;

//PROTOTIPOS E FUNÇOES
MovieClip.prototype.move = function(x, y) {
	_root.jx = x;
	_root.jy = y;
		if (y>0)
		this.gotoAndStop(1);
		else if (y<0)
		this.gotoAndStop(3);
		else if (y==0) {
			if (x>0)
			this.gotoAndStop(4);
			else
			this.gotoAndStop(2);
		}
		
	var b = this.getBounds(this);
	for (i in _root.mapa){
	if (!_root.mapa[i].hitTest(this._x+x+b.xmin, this._y+y+b.ymin+25, true)
	and !_root.mapa[i].hitTest(this._x+x+b.xmax, this._y+y+b.ymin+25, true)
	and !_root.mapa[i].hitTest(this._x+x+b.xmin, this._y+y+b.ymax, true)
	and !_root.mapa[i].hitTest(this._x+x+b.xmax, this._y+y+b.ymax, true)) {
		this.dentro.pes.play();
		this.dentro.maos.play();
		this.dentro.cabeca.play();
		this._x += x;
		this._y += y;
	}else {
		this._x -= x*numeroDeRecuadoDoJogador;
		this._y -= y*numeroDeRecuadoDoJogador;
	}
}
};
jogador.expelir = function (x, y) {
	_root.jogador._x -= x*numeroDeExpelidaDoJogador;
	_root.jogador._y -= y*numeroDeExpelidaDoJogador;
}

//CLASSE HUMANOS
_global.Humano = function(mc) {
	this.mc  = mc;
	this.t = 0;
	Oi = true;
	Nome = true;
	eval(this.mc).onEnterFrame = function () {
		if (_root.jogador.hitTest(this)) {
			_root.jogador.expelir(_root.x, _root.y);
			if (Oi) {
			alertaOi = new Alerta();
			alertaOi.atacar("karen", "Oi " + _root.jogador.nome + ", tudo bom?");
			Oi = false;
			}
		}
		//andar();
	}
	andar = function () {
		this.numeroIda = 1;
		this.multiplo = 100;
		this.t++;
		if (this.t<this.multiplo)
		this.move(-this.numeroIda, 0);
		else if (this.t<(this.multiplo*2))
		this.move(this.numeroIda, 0);
		else if (this.t<(this.multiplo*3))
		this.move(0, -this.numeroIda)
		else if (this.t <(this.multiplo*5))
		this.move(0, this.numeroIda/2);
		else if (this.t>(this.multiplo*6))
		this.t = 0;
	}
}
humano.prototype.conversar = function () {
	trace(this.nome + " esta conversando");
}
humano.prototype.getAnalogia = function () {
	return this.analogia;
}
humano.prototype.setAnalogia = function (analogia) {
	this.analogia = analogia;
	return this.setor;
}
humano.prototype.addProperty("_analogia", humano.prototype.getAnalogia, humano.prototype.setAnalogia);

//CLASSE OBSTACULO

_global.obstaculo = function(tipo, fixo) {
	this.tipo  = tipo;
	this.fixo  = fixo;
};
obstaculo.prototype.hit = function () {
	trace("Hora de expelir");
};

//CLASSE REFRIGERANTE

_global.Elixir = function (mc, recupera) {
	//VARIAVEIS
	this.mc = mc;
	this.recupera = recupera;
	//FIUNÇÃO
	eval(mc).onEnterFrame = function () {
		if(_root.jogador.hitTest(this)){
			this.play();
			delete eval(mc).onEnterFrame;
		}
	}
}
Elixir.prototype.usar = function () {
	jogador.saude += this.saude;
}
Elixir.prototype.pegar = function () {
	with(_root) {
		eval(this.mc).play();
	}
}

//MENSAGENS DE ALERTA

_global.Alerta = function () {
}
Alerta.prototype.atacar = function (foto, mensagem) {
	_root.attachMovie("alerta", "alerta_mc", 5);
	setProperty("alerta_mc", _x, 600);
	setProperty("alerta_mc", _y, 400);
	
	alerta_mc.fundo.attachMovie(foto, "foto", 5);
	alerta_mc.texto.text = mensagem;
	
	alerta_mc.onEnterFrame = function () {
		if (Key.isDown(Key.SPACE)) {
			alerta_mc.removeMovieClip();
		}
	}
}
Alerta.prototype.remover = function () {
	alerta_mc.removeMovieClip();
} 

//CLASSE CHAVE

_global.Chave = function (mc) {
	this.mc = mc;
	this.usada = false;
	eval(mc).onEnterFrame = function () {
		if(_root.jogador.hitTest(this)){
			this.play();
			delete eval(mc).onEnterFrame;
		}
	}
}
Chave.prototype.usar = function () {
	this.usada = true;
}

//CLASSE SHORTAN

_global.ShortAn = function (mc) {
	eval(mc).onEnterFrame = function () {
		if(_root.jogador.hitTest(this)){
			if (Key.isDown(Key.SPACE))
				this.play();
			_root.jogador.expelir(_root.jx, _root.jy);
		}
	}
}

//CLASSE PORTA E CLASSE ESCADA

_global.Porta = function (mc) {
	this.chaveQueAbre = eval(mc).label_txt.chaveQueAbre;	
	this.precisaChave = eval(mc).label_txt.precisaChave;
	this.mc = mc;
	eval(mc).para = false;	
	eval(mc).onEnterFrame = function () 
	{
		this.barreira();
		if(_root.jogador.hitTest(this))
		_root.podeUsarChave = true;
		{
			if (this.precisaChave) 
			{
				if (Key.isDown(Key.SPACE)) 
				{
					if (_root.itens.chave==this.chaveQueAbre){
						eval(mc).para = true;
						barreira.removeMovieClip();
						t=0;
						//this.play();
						this.eval(this.chaveQueAbre).usada = true;
						_root.itens.chave = "";
						_root.itens.Tchave = false;
						delete eval(mc).onEnterFrame;
					}
					if (_root.itens.chave!==this.chaveQueAbre and !eval(mc).para) {
						_root.alertaChave = new Alerta();
						_root.alertaChave.atacar(_root.jogador.nome, "Voce necessita da " + this.chaveQueAbre);
					}
				}
			}
		}
	}
}
_global.Escada = function (mc) {
	eval(mc).onEnterFrame = function () 
	{
		if(_root.jogador.hitTest(this))
		gotoAndPlay(this.destino)
	}
}