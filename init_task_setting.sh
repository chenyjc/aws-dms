# !/bin/bash
script=$(readlink -f "$0")
script_path=$(dirname "$script")

source $script_path/dms.conf

LOGGER_SEVERITY=${1:-LOGGER_SEVERITY_DEBUG}

oldIFS=$IFS
IFS=,


for task_id in $tasks
do

if [ "${task_id:0:4}" = "cdc-"  ]; then
  BatchApplyTimeoutMin_=$BatchApplyTimeoutMin
  BatchApplyTimeoutMax_=$BatchApplyTimeoutMax
elif [ "${task_id:0:9}" = "full-cdc-"  ]; then
  BatchApplyTimeoutMin_=$BatchApplyTimeoutMin
  BatchApplyTimeoutMax_=$BatchApplyTimeoutMax
else
  BatchApplyTimeoutMin_=1
  BatchApplyTimeoutMax_=30
fi

mkdir -p $script_path/json

cat << EOF > $script_path/json/${task_id}_task.json
{
  "TargetMetadata": {
    "TargetSchema": "",
    "SupportLobs": true,
    "FullLobMode": false,
    "LobChunkSize": 0,
    "LimitedSizeLobMode": true,
    "LobMaxSize": 32,
    "InlineLobMaxSize": 0,
    "LoadMaxFileSize": 0,
    "ParallelLoadThreads": 0,
    "ParallelLoadBufferSize": 0,
    "BatchApplyEnabled": true,
    "TaskRecoveryTableEnabled": false
  },
  "FullLoadSettings": {
    "TargetTablePrepMode": "DROP_AND_CREATE",
    "CreatePkAfterFullLoad": false,
    "StopTaskCachedChangesApplied": false,
    "StopTaskCachedChangesNotApplied": false,
    "MaxFullLoadSubTasks": 8,
    "TransactionConsistencyTimeout": 600,
    "CommitRate": 10000
  },
  "Logging": {
    "EnableLogging": true,
    "LogComponents": [
      {
        "Id": "SOURCE_UNLOAD",
        "Severity": "$LOGGER_SEVERITY"
      },
      {
        "Id": "SOURCE_CAPTURE",
        "Severity": "$LOGGER_SEVERITY"
      },
      {
        "Id": "TARGET_LOAD",
        "Severity": "LOGGER_SEVERITY_DEBUG"
      },
      {
        "Id": "TARGET_APPLY",
        "Severity": "LOGGER_SEVERITY_DEBUG"
      },
      {
        "Id": "TASK_MANAGER",
        "Severity": "$LOGGER_SEVERITY"
      }
    ]
  },
  "ControlTablesSettings": {
    "historyTimeslotInMinutes": 5,
    "ControlSchema": "",
    "HistoryTimeslotInMinutes": 5,
    "HistoryTableEnabled": false,
    "SuspendedTablesTableEnabled": false,
    "StatusTableEnabled": false
  },
  "StreamBufferSettings": {
    "StreamBufferCount": 3,
    "StreamBufferSizeInMB": 8,
    "CtrlStreamBufferSizeInMB": 5
  },
  "ChangeProcessingDdlHandlingPolicy": {
    "HandleSourceTableDropped": true,
    "HandleSourceTableTruncated": true,
    "HandleSourceTableAltered": true
  },
  "ErrorBehavior": {
    "DataErrorPolicy": "LOG_ERROR",
    "DataTruncationErrorPolicy": "LOG_ERROR",
    "DataErrorEscalationPolicy": "SUSPEND_TABLE",
    "DataErrorEscalationCount": 0,
    "TableErrorPolicy": "SUSPEND_TABLE",
    "TableErrorEscalationPolicy": "STOP_TASK",
    "TableErrorEscalationCount": 0,
    "RecoverableErrorCount": -1,
    "RecoverableErrorInterval": 5,
    "RecoverableErrorThrottling": true,
    "RecoverableErrorThrottlingMax": 1800,
    "ApplyErrorDeletePolicy": "IGNORE_RECORD",
    "ApplyErrorInsertPolicy": "LOG_ERROR",
    "ApplyErrorUpdatePolicy": "LOG_ERROR",
    "ApplyErrorEscalationPolicy": "LOG_ERROR",
    "ApplyErrorEscalationCount": 0,
    "ApplyErrorFailOnTruncationDdl": false,
    "FullLoadIgnoreConflicts": true,
    "FailOnTransactionConsistencyBreached": false,
    "FailOnNoTablesCaptured": false
  },
  "ChangeProcessingTuning": {
    "BatchApplyPreserveTransaction": true,
    "BatchApplyTimeoutMin": $BatchApplyTimeoutMin_,
    "BatchApplyTimeoutMax": $BatchApplyTimeoutMax_,
    "BatchApplyMemoryLimit": 500,
    "BatchSplitSize": 0,
    "MinTransactionSize": 1000,
    "CommitTimeout": 1,
    "MemoryLimitTotal": 1024,
    "MemoryKeepTime": 60,
    "StatementCacheSize": 50
  }
}
EOF

done
IFS=$oldIFS
ls -l  $script_path/json
