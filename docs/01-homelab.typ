#import "/res/helpers.typ" : *

#show: template.with(
  authors: authors,
  task_number: 1,
  serie_title: "Basic network",
  pictures: none, //image("res/Task2.png", width: 75%),
  abstract: [
    #lorem(20)
  ]
)


= Setup environment
For this lab we will you can use your personnal laptop or a the laboratory computer. We won't need a lot of different tools, but we will need an IDE and a Python packet manager. 

This lab will provide explanation for PyCharm and uv installation. Pycharm is an IDE from JetBrains. It's very powerful and we recommande you tu use it for this course. You're free to use another IDE if you want, but we will provide support for PyCharm only.

UV is a packet manager for Python developed by Astral. It's a modern alternative to pip. It's fast, simple and easy to use. We will use it for this lab. You can find more information about uv on the official website: https://astral.sh/uv/

We will also need Wireshark during this lab to capture and analyze network traffic. More information are provided on a separate document: 
#todo[add link to Wireshark installation guide]


#task[Install tools][

  #subtask[
    Install uv with one of the following commands depending on your operating system: 
    #set text(size: 0.75em)
    #table(
      columns: (1fr, 1fr),
      stroke: none,
      column-gutter: 1.5em,
      [*MacOS / Linux:*], [*Windows:*],
      shell[```
        curl -LsSf https://astral.sh/uv/install.sh | sh
      ```],
      shell[```
        powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
      ```]
    )
  ]

  #subtask[
    Download and install PyCharm from the official website:\ 
    https://www.jetbrains.com/pycharm/download/
  ]

  #subtask[
    Follow the installation and configuration chapter on the separate document
    #todo[add link to Wireshark installation guide]
  ]

]

Now that you have installed the required tools, you can created your repository. It will be the place where you will store your code and work during all this semester. Some part are already done for you, but you will have to complete the missing parts. You can find the repository on the following link: 
#infobox(repository-link)

#task[Setup repository][
  The provided repository is a template for you work. You will have to create your own repository based on this template, open it on your IDE, sync the venv and work on it.

  #subtask[
    Create your own repository by clicking on the "Use this template" button on template repository page: #repository-link
  ]

  #subtask[
    Open PyCharm and use the "Clone Repository" to clone your own repository on your computer. Put the link of your repository and choose a place to put it on your computer. Please avoid to select a place sync by OneDrive, it can cause some issues. 
  ]

  #subtask[
    #grid(
      columns: (1.5fr, 1fr),
      column-gutter: 3em,
      [
        Once the project is open in PyCharm, you can open the `pyproject.toml` file and click on the "uv Sync" button to sync the virtual environment. This will install all the required dependencies for this lab.
      ],
      image("/res/img/uv-sync-button-pycharm.png")
    )
  ]

You are now ready to start the lab! Have fun and don't hesitate to ask for help if you need it.

]

= webpage on laptop (python script), localhost, WS 
#todo[
  [R]
  - explain interface loopback for localhost
]


= laptop dhcp on IIoT Rack, find ip in laptop and router config
#todo[
  [R]
  - get ip with ip/if config and note eth interface
  - connect to router and note both laptop are connected
  - note lease time?
]

= 1 student client, 1 student server, both WS
#todo[
  [R]
  - Explain to switch to eth interface
  - warning anti-virus
]

= something with fix ip by mac for RPI, with short lease or small range, student should increase range / fix ip with static DHCP for RPI MAC
#todo[
  [R]
]

= DNS for webpage on RPI
#todo[
  [R]
]
