# KevScript Tools
## Description

In order to manipulate models, we have created a scripting language that is called **KevScript**.  
*This language is not a [general purpose language](https://en.wikipedia.org/wiki/General-purpose_programming_language)*  

A KevScript engine will take a script and a model as inputs, and return a new model modified according to the script.  
*In other word, KevScript is only a Kevoree-specific transformation language.*

## Implementations
The KevScript grammar is written using [Waxeye](http://waxeye.org/). Waxeye is a parser generator based on parsing expression grammars (PEGs) and it is able to generate parsers in many different languages, such as:
  - Java
  - JavaScript
  - Python
  - C
  - Ruby
  - Scheme

If you want to create your own KevScript interpreter, maybe waxeye can already generate the parser for you.  

## KevScript grammar in Waxeye
```
# KevScript grammar

# Rules
# =====
KevScript           <- ws *((Statement | :Comment eol) ws) :?Comment

Statement           <- Add | Remove | Move | Attach | Detach | Set | AddBinding | DelBinding | Include | Network | AddRepo | Namespace | Start | Stop | Pause

Add                 <- AddToken ws NameList ws :':' ws TypeDef                                  # add group0, group1 : WebSocketGroup

Remove              <- RemoveToken ws NameList                                                  # remove node0, node0.comp1, sync

Move                <- MoveToken ws NameList ws InstancePath                                    # move node0.comp0, node2.* node1

Attach              <- AttachToken ws NameList ws InstancePath                                  # attach node0, node1 group0

Detach              <- DetachToken ws NameList ws InstancePath                                  # detach node0, node1 group0

Set                 <- SetToken ws InstancePath ?(:'/' InstancePath) ws :'=' ws RealString      # set node0.comp0.myAtt = 'foo'

Network             <- NetworkToken ws InstancePath ws String2                                  # network node1.lan.eth0 192.168.0.1

AddBinding          <- BindToken ws InstancePath ws InstancePath                                # bind node1.comp0.sendMsg chan42

DelBinding          <- UnbindToken ws InstancePath ws InstancePath                              # unbind node1.comp0.sendMsg chan0

AddRepo             <- RepoToken ws RealStringNoNewLine                                         # repo "http://org.sonatype.org/foo/bar?a=b&c=d"

Include             <- IncludeToken ws String :':' String2                                      # include npm:kevoree-chan-websocket

NameList            <- InstancePath ws *(:[,] ws InstancePath)                                  # node42

TypeDef             <- TypeFQN ?(:'/' Version)                                                  # FooType/0.0.1 (specific vers.)

TypeFQN             <- String3 *([.] String3)

Namespace           <- NamespaceToken ws String                                                 # namespace sp-ace_0

Start               <- StartToken ws NameList                                                   # start host.child

Stop                <- StopToken ws NameList                                                    # stop child, child1

Pause               <- PauseToken ws NameList                                                   # pause node0.comp

InstancePath        <- (Wildcard | String) *(:[.] (Wildcard | String))                          # node0.*.att

Wildcard            <- '*'

String              <- +[a-zA-Z0-9_-]

String2             <- +[a-zA-Z0-9.:%@_-]

String3             <= +[a-zA-Z0-9_]

Version             <- +[a-zA-Z0-9._-]

Line                <- +(!eol .) 																 # anything but EOL

RealString          <- :['] *(NewLine | Escaped | SingleQuoteLine) :[']
                     | :["] *(NewLine | Escaped | DoubleQuoteLine) :["]

Escaped             <- [\\](!eol .)
SingleQuoteLine     <- +(!['] ![\\] (!eol .))
DoubleQuoteLine     <- +(!["] ![\\] (!eol .))

RealStringNoNewLine <- :['] *([\\](!eol .) | !['] ![\\] (!eol .)) :[']
                     | :["] *([\\](!eol .) | !["] ![\\] (!eol .)) :["]

NewLine             <- :'\r\n' | :'\n' | :'\r'
# =========
# End Rules


# Void Non-terminals
# =============
RepoToken       <: 'repo'
IncludeToken    <: 'include'
AddToken        <: 'add'
RemoveToken     <: 'remove'
MoveToken       <: 'move'
SetToken        <: 'set'
AttachToken     <: 'attach'
DetachToken     <: 'detach'
NetworkToken    <: 'network'
BindToken       <: 'bind'
UnbindToken     <: 'unbind'
NamespaceToken  <: 'namespace'
StartToken      <: 'start'
StopToken       <: 'stop'
PauseToken      <: 'pause'
Comment         <: '//' ?Line
eol             <: '\r\n' | '\n' | '\r'
ws              <: *([ \t] | eol)
# =================
# End Void Non-terminals
```
