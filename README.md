# CRUD com DDD + ORMBr [🚧 Em desenvolvimento]

Projeto de CRUD desenvolvido em Delphi utilizando os princípios do Domain-Driven Design (DDD) e integração com ORMBr para persistência de dados com Firebird.

## Funcionalidades

- Cadastro de clientes
- Atualização e remoção de registros
- Consulta de dados
- Separação em camadas seguindo DDD
- Integração com ORMBr

## Tecnologias utilizadas

- Delphi
- ORMBr
- FireDAC
- Firebird
- Boss

## Como usar

### Clone o repositório

```bash
git clone https://github.com/seu-usuario/nome-do-repo.git
```

### Instale as dependências

Antes de abrir o projeto no Delphi, execute:

```bash
boss install
```

### Configure a DLL do Firebird

Copie o arquivo `fbclient.dll` da raiz do projeto para a pasta onde o executável será executado (`Win32\Debug` ou `Win64\Debug`).

### Execute o projeto

Abra o arquivo `.dproj` no Delphi, compile e execute normalmente.

## Objetivo

Projeto criado para estudo de:

- DDD
- Arquitetura em camadas
- ORMBr
- Boas práticas no Delphi

## Contato

Matheus Campos  
m.campos612003@gmail.com

## Licença

Este projeto está sob a licença MIT.
