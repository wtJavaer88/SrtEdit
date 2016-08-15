'/*===========================================================
' * Intro        ��Ҫת���Ķ���ļ�/�ļ����ϵ����ļ��ϼ���
' * FileName     ConvertCode.vbs
' * Author       Florian
' * Version      v1.0
' * WEB           http://www.cnblogs.com/fanzhidongyzby
' * Email        fanzhidongyzby@163.com
' * LastModify  2014-06-11 00:39:58
' *==========================================================*/

'-------------------------------------------------
'���ñ��룺Ĭ��    utf-8    -->    gb2312
'-------------------------------------------------

SrcCode="UNICODE"
DestCode="gb2312"

'-------------------------------------------------
'��������
'-------------------------------------------------

Set fs = CreateObject("scripting.filesystemobject")
Set objArgs = WScript.Arguments
If objArgs.Count>0 Then
    For I = 0 To objArgs.Count - 1
        FileUrl = objArgs(I)
        Call ConvertDir(FileUrl)
    Next
Else
    MsgBox "û���ļ�/�ļ��б����룡"
    wscript.quit
End If
MsgBox    "ת���ɹ���"

'-------------------------------------------------
'��������:ConvertDir
'����:������Ŀ¼�ڵ��ļ����б���ת��
'-------------------------------------------------

Function ConvertDir(DirUrl)
    If fs.FileExists(DirUrl) Then  
        Call ConvertFile(DirUrl)
    Else
        Call SearchDir(DirUrl)
    End If
End Function


'-------------------------------------------------
'��������:SearchDir
'����:�ݹ����Ŀ¼�ڵ��ļ������б���ת��
'-------------------------------------------------

Function SearchDir(path)    
    Set folder = fs.getfolder(path)
    Set subfolders = folder.subfolders
    Set Files = folder.Files    
    For Each i In Files
        Call ConvertFile(i.path)
    Next    
    For Each j In subfolders        
        Call SearchDir(j.path)
    Next
End Function

'-------------------------------------------------
'��������:ConvertFile
'����:��һ���ļ����б���ת��
'-------------------------------------------------

Function ConvertFile(FileUrl)
    Call WriteToFile(FileUrl, ReadFile(FileUrl, SrcCode), DestCode)
End Function

'-------------------------------------------------
'��������:ReadFile
'����:����AdoDb.Stream��������ȡ���ָ�ʽ���ı��ļ�
'-------------------------------------------------

Function ReadFile(FileUrl, CharSet)
    Dim Str
    Set stm = CreateObject("Adodb.Stream")
    stm.Type = 2
    stm.mode = 3
    stm.charset = CharSet
    stm.Open
    stm.loadfromfile FileUrl
    Str = stm.readtext
    stm.Close
    Set stm = Nothing
    ReadFile = Str
End Function

'-------------------------------------------------
'��������:WriteToFile
'����:����AdoDb.Stream������д����ָ�ʽ���ı��ļ�
'-------------------------------------------------

Function WriteToFile (FileUrl, Str, CharSet)
    Set stm = CreateObject("Adodb.Stream")
    stm.Type = 2
    stm.mode = 3
    stm.charset = CharSet
    stm.Open
    stm.WriteText Str
    stm.SaveToFile FileUrl, 2
    stm.flush
    stm.Close
    Set stm = Nothing
End Function