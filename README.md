# Saborê — Aplicativo de Receitas

## Sobre o projeto

O Saborê é um aplicativo mobile desenvolvido em Flutter que permite explorar, pesquisar e favoritar receitas culinárias de forma simples e intuitiva.

O aplicativo utiliza a API DummyJSON para obter informações sobre diferentes receitas, apresentando imagens, ingredientes, instruções de preparo, avaliações, tempo de preparo e quantidade de porções.

O projeto foi desenvolvido como atividade acadêmica da disciplina de Desenvolvimento Mobile com Flutter, do curso de Engenharia de Software da UniFil.

## Objetivo

O objetivo do projeto é aplicar os conhecimentos adquiridos durante a disciplina, desenvolvendo uma aplicação mobile integrada a uma API externa, utilizando conceitos de navegação, gerenciamento de estado, programação assíncrona e construção de interfaces.

## Funcionalidades

- Listagem de receitas obtidas através de uma API REST.
- Pesquisa de receitas pelo nome.
- Visualização dos detalhes de cada receita.
- Exibição de imagens, avaliações e tipos de refeição.
- Informações sobre tempo de preparo e quantidade de porções.
- Listagem de ingredientes.
- Instruções de preparo organizadas em etapas.
- Adição e remoção de receitas favoritas.
- Controle de receitas favoritas sem duplicidade.
- Manutenção dos favoritos durante a sessão do aplicativo.
- Preservação da pesquisa durante a navegação.
- Indicador de carregamento.
- Tratamento de erros de conexão.
- Validação do campo de pesquisa.
- Mensagem para pesquisas sem resultados.
- Mensagem para lista de favoritos vazia.
- Opção de tentar novamente em caso de falha na requisição.

## Tecnologias utilizadas

- **Flutter:** framework utilizado para o desenvolvimento da aplicação mobile.
- **Dart:** linguagem de programação utilizada no projeto.
- **Material Design 3:** construção e padronização dos componentes visuais.
- **DummyJSON API:** fornecimento dos dados das receitas.
- **HTTP:** biblioteca utilizada para realizar requisições à API.
- **Android Studio:** ambiente de desenvolvimento.
- **Git e GitHub:** controle de versão e armazenamento do código-fonte.

## Integração com a API

O aplicativo utiliza a API pública DummyJSON para consultar os dados das receitas.

Documentação oficial:

https://dummyjson.com/docs/recipes

### Endpoints utilizados

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/recipes` | Listagem de receitas |
| GET | `/recipes/search?q=nome` | Pesquisa de receitas pelo nome |

URL base:

`https://dummyjson.com`

Os dados recebidos em formato JSON são convertidos em objetos da classe `Receita`, permitindo sua utilização nas diferentes telas do aplicativo.

## Estrutura do projeto

```text
lib/
├── models/
│   └── receita.dart
├── pages/
│   ├── inicio.dart
│   └── detalhes_receita.dart
├── services/
│   └── receita_service.dart
└── main.dart
```

### Organização dos arquivos

| Arquivo | Responsabilidade |
|---|---|
| `main.dart` | Inicialização do aplicativo e configuração do tema. |
| `receita.dart` | Modelo responsável por representar os dados das receitas. |
| `receita_service.dart` | Comunicação com a API e tratamento das requisições. |
| `inicio.dart` | Listagem, pesquisa, navegação e gerenciamento dos favoritos. |
| `detalhes_receita.dart` | Exibição das informações detalhadas de uma receita. |

## Telas do aplicativo

### Explorar

Tela inicial responsável por apresentar as receitas disponíveis e permitir que o usuário realize pesquisas pelo nome.

### Detalhes da receita

Apresenta as informações completas da receita selecionada, incluindo imagem, avaliação, ingredientes, tempo de preparo, porções e instruções.

Também permite adicionar ou remover a receita da lista de favoritos.

### Favoritos

Apresenta as receitas salvas pelo usuário durante a utilização do aplicativo.

Caso nenhuma receita tenha sido adicionada, uma mensagem informativa é exibida.

## Gerenciamento de estado

O gerenciamento de estado foi realizado utilizando `StatefulWidget` e `setState()`.

Esses recursos são utilizados para atualizar a interface sempre que ocorre uma alteração, como:

- Carregamento das receitas.
- Realização de pesquisas.
- Alteração da aba selecionada.
- Adição ou remoção de favoritos.
- Ocorrência de erros durante as requisições.

A comunicação entre a tela inicial e a tela de detalhes utiliza callbacks para manter a lista de favoritos atualizada.

Os favoritos são armazenados em memória durante a sessão, sem a utilização de um banco de dados.

## Tratamento de erros e validações

O aplicativo possui mecanismos para lidar com diferentes situações durante sua utilização:

- Falha de conexão com a internet.
- Erros durante a comunicação com a API.
- Pesquisa com campo vazio.
- Pesquisa sem receitas correspondentes.
- Lista de favoritos vazia.
- Carregamento de informações.

Em caso de falha na comunicação com a API, o usuário recebe uma mensagem informativa e pode tentar realizar a requisição novamente.

## Identidade visual

A identidade visual do Saborê foi desenvolvida com o objetivo de proporcionar uma experiência agradável, utilizando uma interface minimalista, cores suaves e componentes de fácil navegação.

### Paleta de cores

| Cor | Código hexadecimal | Aplicação |
|---|---|---|
| Verde principal | `#496747` | Botões e elementos de destaque |
| Bege claro | `#FAF7F0` | Fundo do aplicativo |
| Verde suave | `#DCE8D6` | Elementos secundários e seleção |

## Como executar o projeto

### Pré-requisitos

- Flutter SDK instalado.
- Dart SDK.
- Git.
- Android Studio ou outro editor compatível com Flutter.
- Emulador Android ou dispositivo físico.
- Conexão com a internet.

### 1. Clonar o repositório

```bash
git clone URL_DO_REPOSITORIO
```

### 2. Acessar a pasta do projeto

```bash
cd dudareceitas
```

### 3. Instalar as dependências

```bash
flutter pub get
```

### 4. Verificar o ambiente de desenvolvimento

```bash
flutter doctor
```

### 5. Executar o aplicativo

```bash
flutter run
```

O aplicativo necessita de conexão com a internet para consultar as receitas disponibilizadas pela API.

## Conceitos aplicados

Durante o desenvolvimento do projeto, foram utilizados os seguintes conceitos:

- Programação orientada a objetos.
- Consumo de API REST.
- Manipulação de dados JSON.
- Programação assíncrona com `async` e `await`.
- Utilização de `Future`.
- Gerenciamento de estado.
- Navegação entre telas.
- Comunicação entre widgets através de callbacks.
- Validação de formulários.
- Tratamento de exceções.
- Organização e separação de responsabilidades.
- Desenvolvimento de interfaces mobile.

## Possíveis melhorias futuras

- Armazenamento permanente dos favoritos.
- Filtros por categorias de receitas.
- Cadastro e autenticação de usuários.
- Criação de receitas personalizadas.
- Lista de compras baseada nos ingredientes.
- Planejamento semanal de refeições.
- Suporte ao modo escuro.