function [imageOtsu2] = SeuillageLocaleOtsu2(img,nbrBlockL,nbrBlockC)%l'image puis les deux dernier arguments represente le nombre sur le quelle on veux diviser la matrice 
[nl, nc]=size(img);%r�cuperer la taille de l'image
rslt=zeros(nl,nc);%initialiser la matrice resultante

ql=nl/nbrBlockL;%si pour recuperer la taille d'une matrice a l'int�riere d'un block dans cette variable c'est le nombre de ligne d'un block
qc=nc/nbrBlockC;%le nombre de colomns a l'intere d'un block 

%ql et qc represente la taille de la  petite matrice a l'interiere de la matrice de l'image  sur la quelle on va effectuer loperation otsu2 

k=1;%initialiser  d'indice des ligns

while (k<nl)% parcourir l'image en faisant un saut �gale a ql (nombre de lignes) a chaque it�ration   
        
        l=1;%r�nitialser l'indices des columns pour revenire  chaque fois a la premiere colomns 
       
        while (l<nc)% parcourir l'image en faisant un saut �gale a qc a chaque it�ration  
               matOtsu2=img(k:k+ql-1,l:l+qc-1);%recupere la marice qu'on appleras MATOTSU2 pour calculer la variance  pour chaque bloc ca taille sera ql*qc
               var=zeros(1,256);%tableau de variance initialiser a zeros
               
                       h=histo(matOtsu2,max(matOtsu2(:)));   %appelle a la fonction histo qui va nous calculer l'histogramme 
                       for i=2:max(matOtsu2(:))%pour chercher le bon seuille on va calculer la variance pour chaque seuille de 2 a 256
                           S=0;ws=0;%initialser des valeurs a cumuler 
                           for j=1:i-1 %de 1 jusqu'au seuille ca represente le elements de la classe c1
                                S=S+h(1,j);%les valeurs cumuler de h(1,j) compter tout les element quand la classe c1
                                ws=ws+double(j)*h(1,j);%les valeurs cumuler de j*h(1,j)tl que j et la couleur et h(1,j) est le nombre de fois qu'il revient  
                           end
                           W1=S/(qc*ql);%la probabilite qu'il appartien a la class c1
                           mu1=ws/S;%la mayenne de la classe c1
                           S1=0;ws1=0;%initialser des valeurs a cumuler dans la classe c2
                           for j=i:max(matOtsu2(:))%du seuille jusqu'au max des valeurs qui existe dans la matrice pour compter tout les element de la classe c2
                               S1=S1+h(1,j);%les valeurs cumuler de h(1,j) compter tout les element quand la classe c2
                               ws1=ws1+double(j)*h(1,j);%les valeurs cumuler de j*h(1,j)tl que j et la couleur et h(1,j) est le nombre de fois qu'il revient
                           end
                           W2=S1/(qc*ql);%la probabilite qu'il appartien a la class c2
                           mu2=ws1/S1;%la mayenne de la classe c2
                           var(1,i-1)=W1*W2*(mu1-mu2)*(mu1-mu2);%calculer la fonction de otsu2 qui manimise la variance intra class  
                       end
                       [~, seuille]=max(var);%recupere le meilleure seuille a appliquer a la matrice 

                  for ii=k:k+ql-1%parcourir l'image  recu en parametre (image d'origine) pour comparer a la medianne est affecter sois un 0 ou un 1 selon les indices de la petite matrice MATMED
                       for jj=l:l+qc-1
                            if img(ii,jj)<seuille%la position qu'on recupere avec la fonction max represente notre seuille pour la petite matrice < affecter un 0
                                rslt(ii,jj)=0;%effectuer le seuillage  
                            else%seuille> affecter un 1
                                rslt(ii,jj)=1;
                            end    
                       end
                  end
                       l=l+qc;   %faire un saut selon le qc sp�cifier le nombre de colomns d'un block
        end
      k=k+ql;%faire un saut selon le ql sp�cifier le nombre de lignes d'un block
        
end
    
    imageOtsu2=rslt;

end

