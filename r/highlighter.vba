Sub HighlightBadBehaviour()
    '' Adapted from https://www.extendoffice.com/documents/excel/3775-excel-highlight-part-of-text-in-cell.html

    Dim xStr As String
    Dim xRg As Range
    Dim xTxt As String
    Dim xCell As Range
    Dim xChar As String
    Dim I As Long
    Dim J As Long
    On Error Resume Next
    If ActiveWindow.RangeSelection.Count > 1 Then
      xTxt = ActiveWindow.RangeSelection.AddressLocal
    Else
      xTxt = ActiveSheet.UsedRange.AddressLocal
    End If
LInput:
    ' input prompt
    Set xRg = Application.InputBox("Please select the data range:", "Highlighting for bad behaviour", xTxt, , , , , 8)
    ' edge/error detecting conditions
    If xRg Is Nothing Then Exit Sub
    If xRg.Areas.Count > 1 Then
        MsgBox "Not support multiple columns"
        GoTo LInput
    End If
    If xRg.Columns.Count <> 2 Then
        MsgBox "The selected range can only contain two columns "
        GoTo LInput
    End If
    '' main loop
    ' iterate over rows
    For I = 0 To xRg.Rows.Count - 1
        ' set search string by constructing it as an array, split by comma
        xStr = xRg.Range("B1").Offset(I, 0).Value
        With xRg.Range("A1").Offset(I, 0)
            .Font.ColorIndex = 1
            If Not trim(xStr & vbnullstring) = vbnullstring Then
                For J = 1 To Len(.Text)
                    ' Case insensitive comparison
                    If Mid(LCase(.Text), J, Len(xStr)) = xStr Then
                        If IsFullWord(xStr, Mid(LCase(.Text), J - 1, Len(xStr) + 1)) Then
                            .Characters(J, Len(xStr)).Font.ColorIndex = 3
                        End If
                    End If
                Next
            End If
        End With
    Next I
End Sub

Function IsFullWord(sWord As String, sSearch As String) As Boolean
    Dim sNextChar As String
    Dim lStart As Long
    Dim lEnd As Long

    lStart = InStr(1, sSearch, sWord, vbTextCompare)

    If Not lStart > 0 Then GoTo NotAWord

    'Check if previous character is a space
    If lStart > 1 Then
        If Not Mid(sSearch, lStart - 1, 1) = " " Then GoTo NotAWord
    End If

    'Check if following character is a space or punctuation
    sNextChar = Mid(sSearch, lStart + Len(sWord), 1)
    If Not InStr(1, " .,!", sNextChar) > 0 Then GoTo NotAWord

    IsFullWord = True
    Exit Function

    NotAWord:
    IsFullWord = False
End Function

