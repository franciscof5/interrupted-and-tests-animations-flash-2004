<?php
$db=mysql_connect("localhost", "root", "xxx") or die("Não pude conectar: " . mysql_error());
mysql_select_db("bbb",$db);

$resultado=mysql_query("SELECT nome, morada, telefone, email FROM agenda",$db);
while ($registo=mysql_fetch_array($resultado)) {
echo("$registo[0]<br>");
echo("$registo[1]<br>");
echo("$registo[2]<br>");
echo("$registo[3]<p></p>");
}
mysql_free_result($resultado);
?>