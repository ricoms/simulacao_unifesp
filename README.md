# simulacao_unifesp
Repositório para projeto da UC **Simulação se sistemas**
* pasta para guardar principais referências: https://drive.google.com/drive/folders/0B4BDW57sxsyvRHRPVnVsT04xNlE?usp=sharing
* link para o texto do artigo: https://www.overleaf.com/6125904mkqzzy

# Instalando requisitos do projeto
Em sistema Ubuntu, realizar até o passo 4 deste tutorial:
* https://www.digitalocean.com/community/tutorials/how-to-set-up-r-on-ubuntu-14-04
* e instalar o RStudio https://www.rstudio.com/

Em sistema Windows, seguir as instalações em:
* https://cran.r-project.org/
* https://www.rstudio.com/products/rstudio/download3/

Após instalar o R e R-Studio, aplicar o comando abaixo para instalar o:
* install.packages("shiny")

## Sites importantes para este projeto
* http://shiny.rstudio.com/
* https://www.shinyapps.io/

# Comandos git para puxar (pull) e realizar 'commit' (push)

Clonar o repositório **para sua pasta de trabalho**:

* git clone https://github.com/ricoms/simulacao_unifesp.git

Submeter atualizações do seu projeto local para o repositório (github).

Fique na pasta do seu projeto e digite os seguintes comando:

* git add .
* git commit -m "\<mensagem\>*"
* git push

Obs 1: No lugar de \<mensagem\>, colocar uma mensagem explicativa relativa ao commit. Por exemplo: "Resolução do issue #2"

Caso outro usuário tenha atualizado o repositório (github), para atualizar sua pasta local utilize:

* git pull

Obs 2: Todos os comandos acima devem ser realizados na pasta de trabalho do projeto local (em seu pc).

Qualquer dúvida, há um tutorial do próprio github: https://help.github.com/

E há outros tutoriais também, estes são legais:
* http://gabsferreira.com/instalando-o-git-e-configurando-github/
* https://www.digitalocean.com/community/tutorials/como-instalar-o-git-no-ubuntu-14-04-pt
