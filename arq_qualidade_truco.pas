Program JogoTruco;

	uses crt;

	type
	  iCarta = record 
	    carta: integer;
	    naipe: string;
	    forca: integer;
	  end;
	  iBaralho = array[1..40] of iCarta;
	
	procedure inserirBaralho(var baral: iBaralho);
	var i, n, x: integer;
	    naipes: array[1..4] of string;
	begin
	  writeln('          BARALHO INICIADO E EMBARALHADO. BORA PRO JOGO!');
	  writeln;
	  naipes[1]:= 'Paus'; naipes[2]:= 'Copas';
	  naipes[3]:= 'Espadas'; naipes[4]:= 'Ouro';
	  x:= 1;
	  for i:= 1 to 12 do 
	    for n:= 1 to 4 do
	    begin
	      if (i < 8) or (i > 9) then
	      begin
	        baral[x].carta := i;
	        baral[x].naipe := naipes[n];
	        x := x + 1;
	      end;
	    end;
	end;
	
	procedure embaralhar(var baral: iBaralho);
	var i, j: integer; temp: iCarta;
	begin
	  Randomize;
	  for i := 40 downto 1 do
	  begin
	    j := Random(i) + 1;
	    temp := baral[i];
	    baral[i] := baral[j];
	    baral[j] := temp;
	  end;
	end;
	
	procedure inserirForca(var baral: iBaralho; jok: iCarta; var manilha: integer);
	var i: integer;
	begin
	  // Lógica da Manilha (Próxima carta após a vira)
	  case jok.carta of
	    7:  manilha := 10; 
	    10: manilha := 11; 
	    11: manilha := 12; 
	    12: manilha := 1; 
	    3:  manilha := 4;
	    else manilha := jok.carta + 1;
	  end;
	
	  for i := 1 to 40 do
	  begin
	    case baral[i].carta of
	      4: baral[i].forca := 1;
	      5: baral[i].forca := 2;
	      6: baral[i].forca := 3;
	      7: baral[i].forca := 4;
	      10: baral[i].forca := 5;
	      11: baral[i].forca := 6; 
	      12: baral[i].forca := 7; 
	      1: baral[i].forca := 8; 
	      2: baral[i].forca := 9;  
	      3: baral[i].forca := 10; 
	    end;
	
	    if (baral[i].carta = manilha) then
	    begin
	      if baral[i].naipe = 'Ouro'    then baral[i].forca := 11;
	      if baral[i].naipe = 'Espadas' then baral[i].forca := 12;
	      if baral[i].naipe = 'Copas'   then baral[i].forca := 13;
	      if baral[i].naipe = 'Paus'    then baral[i].forca := 14;
	    end;
	  end;
	end;
	
	procedure corteBaralho(var baral: iBaralho; var corte: integer; var quemCorta: boolean);
	var i, x: integer; 
			novoBaralho: iBaralho;
	begin
	  x := 1;
		if quemCorta = true then //Defini se quem corta é o jogador ou o computador//
		begin
			writeln('          ======================================');  
		  repeat
		    write('          Sua vez de cortar o baralho(1 à 40): ');
		    readln(corte);
		  until (corte >= 1) and (corte <= 40);
		  writeln('          ======================================');
		end
		else
		begin
			corte:= random(39) + 1;
			writeln('          ======================================');
			writeln ('          O computador cortou na posição ', corte, '!');
			writeln('          ======================================'); 
		end;
			
	  for i := corte to 40 do
	  begin
	    novoBaralho[x] := baral[i];
	    x := x + 1;
	  end; 
	  for i := 1 to (corte - 1) do 
	  begin
	    novoBaralho[x] := baral[i];
	    x := x + 1;
	  end;
	  baral := novoBaralho;
	end;
	
	procedure darCartas(var baral: iBaralho; var maoJ, maoC: iBaralho; var jok: iCarta; var manilha: integer; var quemCorta: boolean);
	var i, posiJ, posiC, corte: integer;
	begin
	  posiJ := 1; posiC := 1;
	  corteBaralho(baral, corte, quemCorta);
	  jok := baral[7]; //A "vira" da manilha//
	  inserirForca(baral, jok, manilha);
	  
	  for i := 1 to 6 do
	  begin
	    if (i mod 2 = 1) then  //Condição para alternar quem começa recebendo as cartas//
	    begin
	      maoJ[posiJ] := baral[i];
	      posiJ := posiJ + 1;
	    end
	    else 
	    begin
	      maoC[posiC] := baral[i];
	      posiC := posiC + 1;
	    end;
	  end;
	end;
	
	procedure truco(var pontos_rodada: integer; var quemTrucou: string; var quemPede: string; var fugiu: boolean);
	var
	  opcao, aux_pontos, s, s2: integer;
		adversario: string;
	begin	
		fugiu:= false;
		if pontos_rodada = 1 then
			aux_pontos:= 3
		else
			aux_pontos:= pontos_rodada + 3;  
		if ( quemTrucou = 'J' ) then
		begin
			 adversario:= 'Computador';
			 if pontos_rodada < 9 then
					s:= random(5) + 1
			 else 
			 		s2:= random(3) + 1;
			 if (s in [1..2]) or (s2 in [1..2]) then
			 begin //Computador aceita truco//
			 		pontos_rodada:= aux_pontos;
		      writeln('          Jogo aceito! Valendo ', pontos_rodada);
			 end
			 else if (s in [3..4]) or (s2 = 3) then
			 begin //Computador fugiu do pedido de truco//
			 		fugiu := true;
		      writeln('          O ', adversario, ' correu! Você levou a rodada.');
			 end
			 else if ( s = 5 ) and ( pontos_rodada < 9 ) then
			 begin    //Computador retrucou//
			    pontos_rodada:= aux_pontos;
						 aux_pontos:= aux_pontos + 3; 
						 quemTrucou:= 'C';      
		         quemPede:= 'C';
		         truco(pontos_rodada, quemTrucou, quemPede, fugiu)
			 end;
		end
		else
		begin
			adversario:= 'Você';
			writeln;
			if pontos_rodada = 1 then	
				writeln('          --- O COMPUTADOR PEDIU TRUCO! ---')
			else if pontos_rodada = 3 then
				writeln('          --- O COMPUTADOR PEDIU SEIS! ---')
			else if pontos_rodada = 6 then
				writeln('          --- O COMPUTADOR PEDIU NOVE! ---')
			else
				writeln('          --- O COMPUTADOR PEDIU DOZEEE! ---');
			writeln('          --- O que deseja fazer? ---');
			write('          1 - Aceitar   2 - Correr  ');
			if pontos_rodada < 9 then
					writeln(' 3 - Pedir ', aux_pontos + 3);
			repeat
			    write('          Escolha: ');
			    readln(opcao);
			until (opcao in [1, 2]) or ((opcao = 3) and (pontos_rodada < 9));
		  case opcao of
		    1: begin //Opção para aceitar//
		         pontos_rodada:= aux_pontos;
		         writeln('          Jogo aceito! Valendo ', pontos_rodada);
		       end;
		    2: begin //Opção para correr//
		         fugiu := true;
		         writeln('          ' ,adversario, ' correu! O Computador leva a rodada.');
		       end;
		    3: begin //Opção para retrucar//
		         pontos_rodada:= aux_pontos;
						 aux_pontos:= aux_pontos + 3; 
						 quemTrucou:= 'J';      
		         quemPede:= 'J';
		         truco(pontos_rodada, quemTrucou, quemPede, fugiu);
		       end;
			end;
		end;
	end; 
	
	procedure maoDeOnze(var pontosJ, pontosC, pontos_rodada: integer; var fugiu: boolean; maoJ, maoC: iBaralho);
	var
	  opcao, i, somaForca: integer;
	begin
	  fugiu := false;
	  somaForca := 0;
	
	  //Caso o jogador esteja com 11 pontos//
	  if (pontosJ = 11) and (pontosC < 11) then
	  begin
	  	writeln;
	    writeln('          -----  VOCÊ CHEGOU EM MÃO DE ONZE! ----');
	    writeln;
	    writeln('          Sua mão:');
	    for i := 1 to 3 do
	      writeln('          ', i, ': ', maoJ[i].carta, ' de ', maoJ[i].naipe);
	    writeln;
	    writeln('          Deseja aceitar a partida valendo 3 pontos?');
	    write('          1 - Sim    2 - Não ');
	    writeln;
	    repeat           
	      readln(opcao);
	    until opcao in [1, 2];
	
	    if opcao = 1 then
	      pontos_rodada := 3
	    else
	    begin
	    	writeln;
	      writeln('          Você recusou. O Computador ganhou 1 ponto');
	      writeln;
	      pontosC := pontosC + 1;
	      fugiu := true;
	    end;
	  end
	
	  //Caso o computador esteja com 11 pontos//
	  else if (pontosC = 11) and (pontosJ < 11) then
	  begin
	  	writeln;
	    writeln('          -----  MÃO DE ONZE DO COMPUTADOR! ----');
	    writeln;
	    for i := 1 to 3 do //Lógica do computador, se a média for boa, ele aceita//
				somaForca := somaForca + maoC[i].forca;
	    
	    if somaForca >= 18 then 
	    begin
	    	writeln;
	      writeln('          O Computador analisou as cartas e ACEITOU a mão de onze!');
	      writeln;
	      pontos_rodada := 3;
	    end
	    else
	    begin
	    	writeln;
	      writeln('          O Computador CORREU da mão de onze. Você ganhou 1 ponto');
	      writeln;
	      pontosJ := pontosJ + 1;
	      fugiu := true;
	    end;
	    readkey;
	  end;
	end;
	
	procedure mostraCabecalho ( quedasJ, quedasC: integer; manilha, pontos_rodada, pontosC, pontosJ: integer);
	begin
	  writeln;
	  textcolor(lightblue);
		  writeln('          ==========================================');
		  writeln('          PONTUAÇÃO GERAL: Você ', pontosJ, ' x ' ,pontosC, ' Computador');
		  writeln('          ==========================================');
		textcolor(lightgray);
		  writeln('          A MANILHA DA RODADA É O: ', manilha);
			writeln('          Placar da Rodada:   Você ', quedasJ, ' x ', quedasC, ' Computador');
			writeln('          Rodada Valendo: ', pontos_rodada);
		  writeln('          ==========================================');
	  writeln;
	end;
	
	procedure rodada(var maoJ, maoC: iBaralho; var manilha, pontosC, pontosJ: integer);
	var
	  i, escolha, quedasJ, quedasC, pontos_rodada, sortTrucoC, condEmpate, vale_terceira, xJ, xC, quemInicia: integer;
	  usadaJ, usadaC: array[1..3] of boolean;
	  cartaJ, cartaC: iCarta;
	  fugiu, quemComeca: boolean;
	  quemTrucou, quemPede, primeira_queda, esc_truco: string;
	begin 
	  textcolor(lightgreen);
	  condEmpate:= 0;
	  pontos_rodada:= 1;
	  fugiu:= false;
	  if (pontosJ = 11) or (pontosC = 11) and not( pontosC = pontosJ ) then //Entrada para caso haja mão de onze//
	  begin
	    mostraCabecalho ( quedasJ, quedasC, manilha, pontos_rodada, pontosC, pontosJ );
	    maoDeOnze(pontosJ, pontosC, pontos_rodada, fugiu, maoJ, maoC);
	  end;
	  if fugiu then 
			exit;
	  
		quedasJ:= 0; 
		quedasC:= 0;
	  for i := 1 to 3 do 
			usadaJ[i] := false;
	  for i := 1 to 3 do 
			usadaC[i] := false;
		quemInicia:= random(2) + 1;
  	if ( quemInicia mod 2 = 0 ) then
		  quemComeca:= true
		else 
			quemComeca:= false;
		quemPede:= 'N';
	  for i := 1 to 3 do
	  begin
		  mostraCabecalho ( quedasJ, quedasC, manilha, pontos_rodada, pontosC, pontosJ );	   
	    writeln;
	    writeln('          --- ', i, 'ª QUEDA ---');
	    if (quemComeca = true) then
	    begin
			    writeln;
			    writeln('          Sua mão:');         
			    for escolha := 1 to 3 do
			      if not usadaJ[escolha] then
			        writeln('          ', escolha, ': ', maoJ[escolha].carta, ' de ', maoJ[escolha].naipe); 
			      esc_truco:= 'N';
			      repeat
					    if (quemPede = 'C') or (quemPede = 'N') and ( pontos_rodada < 12 ) then
					    begin
					      if ( pontosC < 11 ) and ( pontosJ < 11 ) and ( pontos_rodada <> 12 ) then
					      begin
								  write('          Você deseja Trucar( S- Sim   N- Não): ');
						      readln( esc_truco );
						      if (esc_truco = 'S') or (esc_truco = 's') then
						      begin
										quemPede:= 'J';      	
									  quemTrucou:= 'J';
						      	truco( pontos_rodada, quemTrucou, quemPede, fugiu); 
										if fugiu = true then
										begin
											if quemPede = 'J' then
											begin
												quedasJ:= 1;
												quedasC:= 0;
												pontosJ:= pontosJ + pontos_rodada;
												break;
										  end
								    	else		
											begin
												quedasC:= 1;
												quedasJ:= 0;
												pontosC:= pontosC + pontos_rodada;
						      			break;
											end;
										end;
									end;
								end;
				      end;
				    until( esc_truco = 'S') or ( esc_truco = 's') or ( esc_truco = 'N') or ( esc_truco = 'n');
				    if fugiu = true then
				    	break;
						repeat
							write('          Escolha uma carta: ');
							readln ( escolha );
						until (escolha in [1..3]) and (not usadaJ[escolha]);
						if (escolha in [1..3]) then
					  begin
							usadaJ[escolha] := true;
					    cartaJ := maoJ[escolha];
					  end;   	    
				  if (quemPede = 'J') or (quemPede = 'N') and ( pontos_rodada < 12 ) and ( pontosC < 11 ) and ( pontosJ < 11 ) then
				  begin
					  if quedasC = 0 then //Condições para Computador pedir truco//
							sortTrucoC:= random(5) + 1
						else
							sortTrucoC:= random(4) + 2;
				    if sortTrucoC = 4 then
				    begin
				    	quemPede:= 'C';
				    	quemTrucou:= 'C';
				    	truco( pontos_rodada, quemTrucou, quemPede, fugiu);
				    	if fugiu = true then
							begin
								if quemPede = 'J' then
								begin
									quedasJ:= 1;
									quedasC:= 0;
									pontosJ:= pontosJ + pontos_rodada;
									break;
								end
								else if quemPede = 'C' then
								begin
									quedasC:= 1;
									quedasJ:= 0;
									pontosC:= pontosC + pontos_rodada;
			      			break;
								end; 
							end;
				    end;
				  end;
			    escolha := 1;
			    while (usadaC[escolha] = true) do 
					   escolha := escolha + 1;
			    usadaC[escolha] := true;
			    cartaC := maoC[escolha];
			    writeln;
			    writeln('          Você jogou: ', cartaJ.carta, ' de ', cartaJ.naipe);
			    writeln;
			    writeln('          Computador jogou: ', cartaC.carta, ' de ', cartaC.naipe);
					writeln;
			end
			else //Condição caso quem começa seja o computador//
			begin
			    writeln('          Sua mão:');         
			    for escolha := 1 to 3 do
			      if not usadaJ[escolha] then
			        writeln('          ', escolha, ': ', maoJ[escolha].carta, ' de ', maoJ[escolha].naipe);
			    if (quemPede = 'J') or ( quemPede = 'N' ) and ( pontos_rodada < 12 ) and ( pontosC < 11 ) and ( pontosJ < 11 ) then
			    begin
						  if quedasC = 0 then //Condições para Computador pedir truco//
								sortTrucoC:= random(4) + 1
							else
								sortTrucoC:= random(4) + 2;
					    if sortTrucoC = 4 then
					    begin
					    	quemPede:= 'C';
					    	quemTrucou:= 'C';
					    	truco( pontos_rodada, quemTrucou, quemPede, fugiu);
					    	if fugiu = true then
								begin
									if quemPede = 'J' then
									begin
										quedasJ:= 1;
										quedasC:= 0;
										pontosJ:= pontosJ + pontos_rodada;
										break;
								  end
							    else if quemPede = 'C' then		
									begin
										quedasC:= 1;
										quedasJ:= 0;
										pontosC:= pontosC + pontos_rodada;
										break;
									end;
								end;
					    end;
					end;
			    escolha := 1;
			    while (usadaC[escolha] = true) do 
					   escolha := escolha + 1;
			    usadaC[escolha] := true;
			    cartaC := maoC[escolha];
			    writeln;
			    writeln('          Computador jogou: ', cartaC.carta, ' de ', cartaC.naipe);
					writeln;
			    esc_truco:= 'N';
			    repeat
				    if (quemPede = 'C') or (quemPede = 'N') and ( pontos_rodada < 12 ) then
					  begin
					    	if ( pontosC < 11 ) and ( pontosJ < 11 ) and ( pontos_rodada <> 12 ) then
					    	begin
								  write('          Você deseja Trucar( S- Sim   N- Não): ');
						      readln( esc_truco );
						      if (esc_truco = 'S') or (esc_truco = 's') then
						      begin
										quemPede:= 'J';      	
									  quemTrucou:= 'J';
						      	truco( pontos_rodada, quemTrucou, quemPede, fugiu); 
										if fugiu = true then
										begin
											if quemPede = 'J' then
											begin
												quedasJ:= 1;
												quedasC:= 0;
												pontosJ:= pontosJ + pontos_rodada;
												break;
										  end
									    else if quemPede = 'C' then		
											begin
												quedasC:= 1;
												quedasJ:= 0;
												pontosC:= pontosC + pontos_rodada;
												break;
											end;
										end;
									end;
								end;	
			      end;
			    until( esc_truco = 'S') or ( esc_truco = 's') or ( esc_truco = 'N') or ( esc_truco = 'n');
			    if fugiu = true then
				    	break;
					repeat
						write('          Escolha uma carta: ');
						readln ( escolha );    
					until (escolha in [1..3]) and (not usadaJ[escolha]);
					usadaJ[escolha]:= true;
					cartaJ:= maoJ[escolha];
					writeln;
					writeln('          Você jogou: ', cartaJ.carta, ' de ', cartaJ.naipe);
					writeln;
			end;
			
			if fugiu = false then
			begin		
		    if cartaJ.forca > cartaC.forca then
		    begin
		      writeln('          >> Você venceu essa queda!');
		      quedasJ:= quedasJ + 1;
		      quemComeca:= true;
		      if ( i = 1) then
		      	primeira_queda:= 'J';
		    end
		    else if cartaC.forca > cartaJ.forca then
			  begin
			      writeln('          >> Computador venceu essa queda!');
			      quedasC:= quedasC + 1;
			      quemComeca:= false;
			      if ( i = 1 ) then
			      	primeira_queda:= 'C';
		    end
		    else
		    begin
		      writeln('          >> Empatou!');
					quedasC := quedasC + 1;
					quedasJ := quedasJ + 1;
					condEmpate:= condEmpate + 1; //Condição para caso empatar uma ou duas rodadas//	
		    end;
		  end;
		  fugiu:= false;
	    if condEmpate = 1 then
	    	quemComeca:= quemComeca
	    else
	    	quemComeca:= quemComeca;
	    	
			if ( i = 3 ) and ( quedasC = quedasJ ) then
			begin
				 if primeira_queda = 'C' then
				 		pontosC:= pontosC + pontos_rodada
				 else
				    pontosJ:= pontosJ + pontos_rodada;
				 break;
			end 
			else
			begin
		    if CondEmpate = 2 then
		    	 vale_terceira:= 3
		    else
		    	vale_terceira:= 2;
		    if quedasJ = vale_terceira then 
		    begin
		    	pontosJ:= pontosJ + pontos_rodada;
					break;
				end;
		    if quedasC = vale_terceira then 
		    begin
		    	pontosC:= pontosC + pontos_rodada;
					break;
				end;
			end;
				
	    readkey;
	    ClrScr;
	  end;
		readkey;
		ClrScr;		
	end;
	  
	procedure partida (var maoJ, maoC, bar: iBaralho; jok: iCarta; manilha: integer; var quemCorta: boolean);
	var pontos_gerais, pontosC, pontosJ: integer;
	begin
	    quemCorta:= true;
	    while (pontosC <=11) and (pontosJ <=11) do
	    begin
	      embaralhar(bar);
	      darCartas(bar, maoJ, maoC, jok, manilha, quemCorta);
	    	rodada ( maoJ, maoC, manilha, pontosC, pontosJ);
	    	if quemCorta = true then 
					quemCorta := false 
				else 
					quemCorta := true;
	    	ClrScr;
	    end;
	    writeln;
	    writeln;                    
	    writeln('          ======================');
	    if pontosC >= 12 then
	    	writeln ('          VOCÊ PERDEU À PARTIDA!')
	    else 
	    	writeln ('          VOCÊ VENCEU À PARTIDA!');
	    writeln('          ======================');
	    readkey;                                         
	end;
	
	
	
	var
	  baralho: iBaralho;
	  maoJogador: iBaralho;
	  maoComputador: iBaralho;
	  joker: iCarta;
	  manilha: integer;
	  corteC: boolean;
	
Begin
  inserirBaralho(baralho);
  partida (maoJogador, maoComputador, baralho, joker, manilha, corteC);
End.