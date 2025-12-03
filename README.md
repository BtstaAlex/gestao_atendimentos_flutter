# 📱 Gestão de Atendimentos - Flutter

Sistema completo de gestão de atendimentos desenvolvido em Flutter, permitindo criar, gerenciar e executar atendimentos com captura de imagens e armazenamento local.

---

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Funcionalidades](#-funcionalidades)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Arquitetura](#-arquitetura)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação](#-instalação)
- [Como Executar](#-como-executar)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Fluxo de Uso](#-fluxo-de-uso)
- [Screenshots](#-screenshots)
- [Desenvolvimento](#-desenvolvimento)
- [Troubleshooting](#-troubleshooting)
- [Autor](#-autor)

---

## 🎯 Sobre o Projeto

O **Gestão de Atendimentos** é um aplicativo mobile desenvolvido como trabalho acadêmico para a disciplina de Flutter. O sistema permite o gerenciamento completo de atendimentos de serviços, desde a criação até a finalização com registro fotográfico.

### Objetivo

Criar um sistema que permita:
- Cadastrar atendimentos de forma simples e rápida
- Controlar o status de cada atendimento (Ativo, Em Andamento, Finalizado)
- Registrar fotograficamente o trabalho realizado
- Armazenar observações e relatórios
- Manter histórico completo local no dispositivo

---

## ✨ Funcionalidades

### 📝 Listagem de Atendimentos
- Visualização de todos os atendimentos cadastrados
- Filtros por status:
  - **Todos**: Exibe todos os atendimentos ativos
  - **Ativos**: Atendimentos criados mas não iniciados
  - **Em Andamento**: Atendimentos que foram iniciados
  - **Finalizados**: Atendimentos concluídos com foto e observações
- Exibição de:
  - Status visual com ícones coloridos
  - Data de criação
  - Indicador de foto (quando disponível)
- Ações disponíveis:
  - 👁️ **Ver**: Visualizar detalhes completos
  - ▶️ **Iniciar**: Mudar status para "Em Andamento"
  - ✅ **Realizar**: Executar o atendimento (capturar foto + observações)
  - ✏️ **Editar**: Modificar título e descrição
  - 🗑️ **Excluir**: Exclusão lógica (soft delete)
  - ♻️ **Ativar**: Reativar atendimentos excluídos

### 📋 Criar/Editar Atendimento
- Formulário simples com validação
- Campos obrigatórios:
  - **Título**: Nome do atendimento
  - **Descrição**: Detalhes do serviço a ser realizado
- Status inicial automático: "Ativo"

### 🎯 Realizar Atendimento
Esta é a tela principal de execução do atendimento. Permite:
- Visualizar dados do atendimento selecionado
- Capturar imagem do trabalho realizado usando:
  - 📷 **Câmera**: Tirar foto na hora
  - 🖼️ **Galeria**: Selecionar foto existente
- Adicionar observações ou relatório detalhado
- Finalizar atendimento (mudando status para "Finalizado")
- Armazenamento automático da imagem localmente

### 🔍 Visualizar Detalhes
- Dialog completo e estilizado mostrando:
  - Título e descrição
  - Status atual formatado
  - Data de criação
  - Data de finalização (se aplicável)
  - Observações adicionadas
  - **Imagem do atendimento** (se houver)

---

## 🛠️ Tecnologias Utilizadas

### Principais Dependências

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| **Flutter** | SDK >= 3.0.0 | Framework de desenvolvimento mobile |
| **Dart** | >= 3.0.0 | Linguagem de programação |
| **flutter_bloc** | ^8.1.3 | Gerenciamento de estado com padrão Cubit |
| **sqflite** | ^2.3.0 | Banco de dados SQLite local |
| **path** | ^1.8.3 | Manipulação de caminhos de arquivos |
| **image_picker** | ^1.0.4 | Captura e seleção de imagens |
| **get_it** | ^7.6.4 | Injeção de dependências |

### Por que estas tecnologias?

#### 🎨 **Flutter Bloc (Cubit)**
- Gerenciamento de estado previsível e testável
- Separação clara entre lógica de negócio e UI
- Facilita manutenção e escalabilidade

#### 💾 **SQLite (sqflite)**
- Banco de dados relacional leve e rápido
- Armazenamento local persistente
- Não requer conexão com internet
- Ideal para aplicações mobile

#### 📸 **Image Picker**
- Acesso nativo à câmera e galeria
- Suporte multiplataforma (Android/iOS)
- Compressão e otimização de imagens

#### 💉 **GetIt**
- Injeção de dependências simples e eficiente
- Facilita testes unitários
- Desacoplamento de código

---

## 🏗️ Arquitetura

O projeto segue uma **arquitetura em camadas** (Clean Architecture) com separação clara de responsabilidades:

```
┌─────────────────────────────────────────────────┐
│          PRESENTATION LAYER (UI)                │
│  - Screens (Telas)                              │
│  - Widgets                                      │
│  - Cubits (Gerenciamento de Estado)            │
│  - States                                       │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│           DATA LAYER (Dados)                    │
│  - Repositories (Regras de Negócio)            │
│  - Data Sources (Acesso ao BD)                  │
│  - Models (Entidades)                           │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│         INFRASTRUCTURE (SQLite)                 │
│  - Database Helper                              │
│  - Local Storage                                │
└─────────────────────────────────────────────────┘
```

### Camadas do Projeto

#### 📱 **Presentation Layer**
Responsável pela interface e interação com usuário:
- **Screens**: Telas do aplicativo
  - `lista_atendimentos_screen.dart`: Tela principal com listagem
  - `form_atendimento_screen.dart`: Formulário de criação/edição
  - `realizar_atendimento_screen.dart`: Tela de execução do atendimento
- **Cubits**: Lógica de gerenciamento de estado
  - `atendimento_cubit.dart`: Gerencia todas as operações de atendimentos
- **States**: Estados possíveis da aplicação
  - `atendimento_state.dart`: Define estados (Loading, Loaded, Error, etc.)

#### 💾 **Data Layer**
Responsável pelo acesso e manipulação de dados:
- **Models**: Representação dos dados
  - `atendimento_model.dart`: Modelo de atendimento com conversão para/do banco
- **Data Sources**: Acesso direto ao banco de dados
  - `database_helper.dart`: Helper do SQLite com operações CRUD
- **Repositories**: Camada de abstração para acesso aos dados
  - `atendimento_repository.dart`: Expõe métodos de alto nível para manipular atendimentos

#### 🔧 **Core**
- **Dependency Injection**: `injection.dart` - Configuração do GetIt

---

## 📋 Pré-requisitos

Antes de começar, você precisa ter instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão 3.0.0 ou superior)
- [Dart SDK](https://dart.dev/get-dart) (versão 3.0.0 ou superior)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/)
- Emulador Android ou dispositivo físico
- Git (para clonar o repositório)

### Verificar Instalação

```bash
flutter doctor
```

Este comando verifica se todas as dependências estão instaladas corretamente.

---

## 🚀 Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/BtstaAlex/gestao_atendimentos_flutter.git
cd gestao-atendimentos
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure as permissões

#### Android

Abra `android/app/src/main/AndroidManifest.xml` e verifique se contém:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Permissões -->
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    
    <application ...>
        ...
    </application>
</manifest>
```

#### iOS

Abra `ios/Runner/Info.plist` e verifique se contém:

```xml
<dict>
    ...
    <key>NSCameraUsageDescription</key>
    <string>Precisamos acessar a câmera para capturar fotos dos atendimentos</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Precisamos acessar a galeria para selecionar fotos</string>
    ...
</dict>
```

---

## ▶️ Como Executar

### Modo Debug (Desenvolvimento)

```bash
flutter run
```

### Modo Release (Produção)

```bash
flutter run --release
```

### Executar em dispositivo específico

```bash
# Listar dispositivos disponíveis
flutter devices

# Executar em dispositivo específico
flutter run -d <device-id>
```

### Build APK (Android)

```bash
flutter build apk --release
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

### Build iOS (necessário macOS)

```bash
flutter build ios --release
```

---

## 📁 Estrutura do Projeto

```
gestao_atendimentos/
│
├── android/                    # Configurações Android
├── ios/                        # Configurações iOS
├── lib/                        # Código-fonte principal
│   │
│   ├── data/                   # Camada de Dados
│   │   ├── datasources/
│   │   │   └── database_helper.dart          # SQLite helper
│   │   ├── models/
│   │   │   └── atendimento_model.dart        # Modelo de dados
│   │   └── repositories/
│   │       └── atendimento_repository.dart   # Repositório
│   │
│   ├── presentation/           # Camada de Apresentação
│   │   ├── cubits/
│   │   │   ├── atendimento_cubit.dart        # Lógica de negócio
│   │   │   └── atendimento_state.dart        # Estados
│   │   └── screens/
│   │       ├── lista_atendimentos_screen.dart    # Tela principal
│   │       ├── form_atendimento_screen.dart      # Formulário
│   │       └── realizar_atendimento_screen.dart  # Realizar atendimento
│   │
│   ├── injection.dart          # Injeção de dependências
│   └── main.dart               # Ponto de entrada da aplicação
│
├── pubspec.yaml                # Dependências do projeto
└── README.md                   # Este arquivo
```

---

## 🎮 Fluxo de Uso

### 1️⃣ Criar Atendimento

```
Tela Inicial → Botão (+) → Preencher Formulário → Salvar
```

- Status inicial: **ATIVO** (ícone azul)
- Campos: Título e Descrição

### 2️⃣ Iniciar Atendimento

```
Lista → Menu (⋮) do Atendimento → Iniciar
```

- Status muda para: **EM ANDAMENTO** (ícone laranja)
- Agora pode ser realizado

### 3️⃣ Realizar Atendimento

```
Lista → Menu (⋮) do Atendimento → Realizar
```

Na tela de realização:
1. Visualize os dados do atendimento
2. Capture uma foto (Câmera ou Galeria)
3. Adicione observações
4. Clique em "Finalizar Atendimento"

- Status muda para: **FINALIZADO** (ícone verde)

### 4️⃣ Visualizar Atendimento Completo

```
Lista → Menu (⋮) do Atendimento → Ver
```

Exibe dialog com:
- Todas as informações
- Data de criação e finalização
- Observações
- **Foto do atendimento** (se houver)

### 5️⃣ Filtrar Atendimentos

```
Tela Inicial → Ícone Filtro (topo) → Selecionar Status
```

Opções:
- Todos
- Ativos
- Em Andamento
- Finalizados

### 6️⃣ Outras Ações

- **Editar**: Modificar título e descrição
- **Excluir**: Remove da lista (soft delete)
- **Ativar**: Restaura atendimento excluído

---

## 📸 Screenshots

### Tela Principal
```
┌─────────────────────────────────┐
│ Gestão de Atendimentos     [≡]  │
├─────────────────────────────────┤
│                                 │
│  🔵  Instalação Elétrica    ⋮   │
│      Trocar fiação sala 201     │
│      Criado em: 03/12/2024      │
│                                 │
│  🟠  Manutenção Ar Cond.    ⋮   │
│      Limpeza geral        [📷]  │
│      Criado em: 03/12/2024      │
│                                 │
│  🟢  Pintura Externa        ⋮   │
│      Pintar fachada       [📷]  │
│      Criado em: 02/12/2024      │
│                                 │
└─────────────────────────────────┘
                 [+]
```

### Tela de Realizar Atendimento
```
┌─────────────────────────────────┐
│ ← Realizar Atendimento          │
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ Manutenção Ar Condicionado  │ │
│ │ Limpeza completa do ar...   │ │
│ │ Status: Em Andamento        │ │
│ └─────────────────────────────┘ │
│                                 │
│ Captura de Imagem *             │
│ ┌─────────────────────────────┐ │
│ │                             │ │
│ │      [FOTO PREVIEW]         │ │
│ │                             │ │
│ └─────────────────────────────┘ │
│                                 │
│  [📷 Câmera]  [🖼️ Galeria]     │
│                                 │
│ Observações                     │
│ ┌─────────────────────────────┐ │
│ │ Digite observações...       │ │
│ │                             │ │
│ └─────────────────────────────┘ │
│                                 │
│    [✅ Finalizar Atendimento]   │
└─────────────────────────────────┘


## 🐛 Troubleshooting

### Problema: Erro ao capturar imagem

**Solução**: Verifique se as permissões estão configuradas corretamente no `AndroidManifest.xml` e `Info.plist`.

```bash
# Reinstalar o app após adicionar permissões
flutter clean
flutter run
```

### Problema: Banco de dados não cria

**Solução**: Desinstale o app do dispositivo e execute novamente.

```bash
# Desinstalar e reinstalar
flutter clean
flutter run
```

### Problema: Erro de build

**Solução**: Limpe o cache e reinstale dependências.

```bash
flutter clean
flutter pub get
flutter run
```

### Problema: Imagem não aparece na visualização

**Solução**: Verifique se o caminho da imagem está sendo salvo corretamente. O caminho deve ser absoluto.

---

## 🎓 Conceitos Aprendidos

Este projeto demonstra conhecimento em:

- ✅ **Arquitetura em Camadas** (Clean Architecture)
- ✅ **Gerenciamento de Estado** com Cubit/BLoC
- ✅ **Persistência Local** com SQLite
- ✅ **Captura de Mídia** (câmera e galeria)
- ✅ **Injeção de Dependências** com GetIt
- ✅ **CRUD Completo** (Create, Read, Update, Delete)
- ✅ **Soft Delete** (exclusão lógica)
- ✅ **Navegação** entre telas
- ✅ **Validação** de formulários
- ✅ **Tratamento de Erros**
- ✅ **UI/UX** responsiva e intuitiva
- ✅ **Máquina de Estados** (status do atendimento)

---

## 📚 Referências

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [SQLite Plugin](https://pub.dev/packages/sqflite)
- [Image Picker](https://pub.dev/packages/image_picker)
- [GetIt](https://pub.dev/packages/get_it)
- [Material Design](https://m3.material.io/)

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos.

---

## 👤 Autor

**Trabalho Acadêmico - Disciplina de Flutter**

📅 **Data de Apresentação**: 03/12/2024

---

## 🎉 Agradecimentos

Agradecimentos especiais ao professor e colegas de turma pelo suporte durante o desenvolvimento deste projeto.

---