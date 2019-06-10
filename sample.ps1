[System.Data.SqlClient.SqlConnection]$objConnection = $null;
[System.Data.SqlClient.SqlCommand]$objCommand       = $null;
[System.Data.SqlClient.SqlDataAdapter]$objAdapter   = $null;
[System.Data.DataSet]$objDataset = $null;
[System.Data.DataTable]$objTable = $null;
[string]$strServer = '<SQL DB URL>';
[string]$strInstance = ''; 
[string]$strDatabase = '<sqldb>';
[string]$strSQL = '';
[string]$strConnectionString  = '';
[Boolean]$integratedSecurity=$FALSE;
[string]$userID='<userid>';
[string]$passwd='<password>';

# $strServer   = 'localhost'; #サーバーを指定
# $strInstance = 'SQLEXPRESS';#インスタンスを指定
# $strDatabase = 'テスト';    #データベースを指定

#実行するSQL
#$strSQL = "WAITFOR DELAY '00:00:05'; ";
$strSQL = "SELECT 1";

#接続文字列を作成
#windows認証を使用する場合、Integrated Security=True にする。
$strConnectionString = @"
Data Source=$(if(($strInstance.trim()) -eq ""){ Write-Output $strServer }else{ Write-Output $strServer\$strInstance  });
Initial Catalog=$strDatabase;
Integrated Security=$integratedSecurity;
User ID=$userID;
Password=$passwd;
"@ 

$strConnectionString

$objConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection;
$objConnection.ConnectionString = $strConnectionString;
Write-Host $objConnection.ConnectionTimeout;
$objCommand = $objConnection.CreateCommand();
$objCommand.CommandText = $strSQL;
 
$objAdapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter $objCommand;
$objDataset = New-Object -TypeName System.Data.DataSet;
 
#データセットにCommandTextの実行結果をセット
#戻り値の数値は不要の為、[void]をつけている。
[void]$objAdapter.Fill($objDataset);
 
#DataSetにセットされた1個目のテーブルを取り出す
$objTable = $objDataset.Tables[0];
 
##Write-Host '***** データの１行目を表示 *****';
##if($objTable.Rows.Count -gt 0){
##  Write-Host ('1行目のID   ：' + $objTable.Rows[0].Item('ID'));
##  Write-Host ('1行目のNAME ：' + $objTable.Rows[0].Item('NAME'));
##  Write-Host ('1行目のPRICE：' + $objTable.Rows[0].Item('PRICE'));
##}else{
##  Write-Host 'データはありません。';
##}
## 
##Write-Host '***** データを全件ループして表示 *****';
foreach($objRow in $objTable.Rows){
    Write-Host ('Result:'     + $objRow.Item('Column1'))
} 
 
#各種リソースの破棄
$objConnection.Close();
$objConnection.Dispose();
$objCommand.Dispose();
$objDataset.Dispose();
$objAdapter.Dispose(); 