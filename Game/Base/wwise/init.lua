wwise = {}
hasffi, ffi = pcall(require, "ffi")

function wwise.load(connect_to_wwise)
  wwise.errors = {
"This feature is not implemented.",
"The operation was successful.",
"The operation failed.",
"The operation succeeded partially.",
"Incompatible formats",
"The stream is already connected to another node.",
"Trying to open a file when its name was not set",
"An unexpected value causes the file to be invalid.",
"The file header is too large.",
"The maximum was reached.",
"Inputs are currently used.",
"Outputs are currently used.",
"The name is invalid.",
"The name is already in use.",
"The ID is invalid.",
"The ID was not found.",
"The InstanceID is invalid.",
"No more data is available from the source.",
"There is no child (source) associated with the node.",
"The StateGroup already exists.",
"The StateGroup is not a valid channel.",
"The child already has a parent.",
"The language is invalid (applies to the Low-Level I/O).",
"It is not possible to add itself as its own child.",
"The transition is not in the list.",
"Start allowed in the Running and Done states.",
"Must not be in the Computing state.",
"No one can be added any more, could be AK_MaxReached.",
"This user is already there.",
"This user is not there.",
"Not in use.",
"Something is not within bounds.",
"Something was not within bounds and was relocated to the nearest OK value.",
"The sound has 3D parameters.",
"The sound does not have 3D parameters.",
"The item could not be added because it was already in the list.",
"This path is not known.",
"Stuff in vertices before trying to start it",
"Only a running path can be paused.",
"Only a paused path can be resumed.",
"This path is already there.",
"This path is not there.",
"Unknown in our voices list",
"The consumer needs more.",
"The consumer does not need more.",
"The provider has available data.",
"The provider does not have available data.",
"Not enough space to load bank.",
"Bank error.",
"No need to fetch new data.",
"Debug mode only.",
"The memory manager's block list has been corrupted.",
"Memory error.",
"The requested action was cancelled (not an error).",
"Trying to load a bank using an ID which is not defined.",
"Asynchronous pipeline component is processing.",
"Error while reading a bank.",
"Invalid switch type (used with the switch container)",
"Internal use only.",
"This environment is not defined.",
"This environment is used by an object.",
"This object is not defined.",
"Audio data already in target format, no conversion to perform.",
"Source format not known yet.",
"The bank version is not compatible with the current bank reader.",
"The provider has some data but does not process it (virtual voices).",
"File not found.",
"IO device not ready (may be because the tray is open)",
"The direct sound secondary buffer creation failed.",
"The bank load failed because the bank is already loaded.",
"The effect on the node is rendered.",
"A routine needs to be executed on some CPU.",
"The executed routine has finished its execution.",
"The memory manager should have been initialized at this point.",
"The stream manager should have been initialized at this point.",
"The machine does not support SSE instructions (required on PC).",
"The system is busy and could not process the request.",
"Channel configuration is not supported in the current execution context.",
"Plugin media is not available for effect.",
"Sound was Not Allowed to play.",
"SDK command is too large to fit in the command queue.",
"A play request was rejected due to the MIDI filter parameters.",
"Detecting incompatibility between Custom platform of banks and custom platform of connected application",
"DLL could not be loaded, either because it is not found or one dependency is missing."
}

  ffi.cdef[[
  typedef enum AKRESULT
{
    AK_NotImplemented			= 0,	///< This feature is not implemented.
    AK_Success					= 1,	///< The operation was successful.
    AK_Fail						= 2,	///< The operation failed.
    AK_PartialSuccess			= 3,	///< The operation succeeded partially.
    AK_NotCompatible			= 4,	///< Incompatible formats
    AK_AlreadyConnected			= 5,	///< The stream is already connected to another node.
    AK_NameNotSet				= 6,	///< Trying to open a file when its name was not set
    AK_InvalidFile				= 7,	///< An unexpected value causes the file to be invalid.
    AK_AudioFileHeaderTooLarge	= 8,	///< The file header is too large.
    AK_MaxReached				= 9,	///< The maximum was reached.
    AK_InputsInUsed				= 10,	///< Inputs are currently used.
    AK_OutputsInUsed			= 11,	///< Outputs are currently used.
    AK_InvalidName				= 12,	///< The name is invalid.
    AK_NameAlreadyInUse			= 13,	///< The name is already in use.
    AK_InvalidID				= 14,	///< The ID is invalid.
    AK_IDNotFound				= 15,	///< The ID was not found.
    AK_InvalidInstanceID		= 16,	///< The InstanceID is invalid.
    AK_NoMoreData				= 17,	///< No more data is available from the source.
    AK_NoSourceAvailable		= 18,	///< There is no child (source) associated with the node.
	AK_StateGroupAlreadyExists	= 19,	///< The StateGroup already exists.
	AK_InvalidStateGroup		= 20,	///< The StateGroup is not a valid channel.
	AK_ChildAlreadyHasAParent	= 21,	///< The child already has a parent.
	AK_InvalidLanguage			= 22,	///< The language is invalid (applies to the Low-Level I/O).
	AK_CannotAddItseflAsAChild	= 23,	///< It is not possible to add itself as its own child.
	//AK_TransitionNotFound		= 24,	///< The transition is not in the list.
	//AK_TransitionNotStartable	= 25,	///< Start allowed in the Running and Done states.
	//AK_TransitionNotRemovable	= 26,	///< Must not be in the Computing state.
	//AK_UsersListFull			= 27,	///< No one can be added any more, could be AK_MaxReached.
	//AK_UserAlreadyInList		= 28,	///< This user is already there.
	AK_UserNotInList			= 29,	///< This user is not there.
	AK_NoTransitionPoint		= 30,	///< Not in use.
	AK_InvalidParameter			= 31,	///< Something is not within bounds.
	AK_ParameterAdjusted		= 32,	///< Something was not within bounds and was relocated to the nearest OK value.
	AK_IsA3DSound				= 33,	///< The sound has 3D parameters.
	AK_NotA3DSound				= 34,	///< The sound does not have 3D parameters.
	AK_ElementAlreadyInList		= 35,	///< The item could not be added because it was already in the list.
	AK_PathNotFound				= 36,	///< This path is not known.
	AK_PathNoVertices			= 37,	///< Stuff in vertices before trying to start it
	AK_PathNotRunning			= 38,	///< Only a running path can be paused.
	AK_PathNotPaused			= 39,	///< Only a paused path can be resumed.
	AK_PathNodeAlreadyInList	= 40,	///< This path is already there.
	AK_PathNodeNotInList		= 41,	///< This path is not there.
	AK_VoiceNotFound			= 42,	///< Unknown in our voices list
	AK_DataNeeded				= 43,	///< The consumer needs more.
	AK_NoDataNeeded				= 44,	///< The consumer does not need more.
	AK_DataReady				= 45,	///< The provider has available data.
	AK_NoDataReady				= 46,	///< The provider does not have available data.
	AK_NoMoreSlotAvailable		= 47,	///< Not enough space to load bank.
	AK_SlotNotFound				= 48,	///< Bank error.
	AK_ProcessingOnly			= 49,	///< No need to fetch new data.
	AK_MemoryLeak				= 50,	///< Debug mode only.
	AK_CorruptedBlockList		= 51,	///< The memory manager's block list has been corrupted. '
	AK_InsufficientMemory		= 52,	///< Memory error.
	AK_Cancelled				= 53,	///< The requested action was cancelled (not an error).
	AK_UnknownBankID			= 54,	///< Trying to load a bank using an ID which is not defined.
    AK_IsProcessing             = 55,   ///< Asynchronous pipeline component is processing.
	AK_BankReadError			= 56,	///< Error while reading a bank.
	AK_InvalidSwitchType		= 57,	///< Invalid switch type (used with the switch container)
	AK_VoiceDone				= 58,	///< Internal use only.
	AK_UnknownEnvironment		= 59,	///< This environment is not defined.
	AK_EnvironmentInUse			= 60,	///< This environment is used by an object.
	AK_UnknownObject			= 61,	///< This object is not defined.
	AK_NoConversionNeeded		= 62,	///< Audio data already in target format, no conversion to perform.
    AK_FormatNotReady           = 63,   ///< Source format not known yet.
	AK_WrongBankVersion			= 64,	///< The bank version is not compatible with the current bank reader.
	AK_DataReadyNoProcess		= 65,	///< The provider has some data but does not process it (virtual voices).
    AK_FileNotFound             = 66,   ///< File not found.
    AK_DeviceNotReady           = 67,   ///< IO device not ready (may be because the tray is open)
    AK_CouldNotCreateSecBuffer	= 68,   ///< The direct sound secondary buffer creation failed.
	AK_BankAlreadyLoaded		= 69,	///< The bank load failed because the bank is already loaded.
	AK_RenderedFX				= 71,	///< The effect on the node is rendered.
	AK_ProcessNeeded			= 72,	///< A routine needs to be executed on some CPU.
	AK_ProcessDone				= 73,	///< The executed routine has finished its execution.
	AK_MemManagerNotInitialized	= 74,	///< The memory manager should have been initialized at this point.
	AK_StreamMgrNotInitialized	= 75,	///< The stream manager should have been initialized at this point.
	AK_SSEInstructionsNotSupported = 76,///< The machine does not support SSE instructions (required on PC).
	AK_Busy						= 77,	///< The system is busy and could not process the request.
	AK_UnsupportedChannelConfig = 78,	///< Channel configuration is not supported in the current execution context.
	AK_PluginMediaNotAvailable  = 79,	///< Plugin media is not available for effect.
	AK_MustBeVirtualized		= 80,	///< Sound was Not Allowed to play.
	AK_CommandTooLarge			= 81,	///< SDK command is too large to fit in the command queue.
	AK_RejectedByFilter			= 82,	///< A play request was rejected due to the MIDI filter parameters.
	AK_InvalidCustomPlatformName= 83,	///< Detecting incompatibility between Custom platform of banks and custom platform of connected application
	AK_DLLCannotLoad			= 84	///< DLL could not be loaded, either because it is not found or one dependency is missing.
} AKRESULT;

  typedef char			AkInt8;					///< Signed 8-bit integer
  typedef short			AkInt16;				///< Signed 16-bit integer
  typedef long   			AkInt32;				///< Signed 32-bit integer
  typedef __int64			AkInt64;				///< Signed 64-bit integer

  typedef wchar_t			AkOSChar;				///< Generic character string

  typedef float			AkReal32;				///< 32-bit floating point
  typedef double          AkReal64;				///< 64-bit floating point
  
  typedef unsigned char		AkUInt8;			///< Unsigned 8-bit integer
  typedef unsigned short		AkUInt16;			///< Unsigned 16-bit integer
  typedef unsigned long		AkUInt32;			///< Unsigned 32-bit integer
  typedef unsigned __int64	AkUInt64;			///< Unsigned 64-bit integer
  
  typedef int AkIntPtr;						///< Integer type for pointers
  typedef unsigned int AkUIntPtr;			///< Integer (unsigned) type for pointers

  typedef AkUInt32		AkUniqueID;			 		///< Unique 32-bit ID
  typedef AkUInt32		AkStateID;			 		///< State ID
  typedef AkUInt32		AkStateGroupID;		 		///< State group ID
  typedef AkUInt32		AkPlayingID;		 		///< Playing ID
  typedef	AkInt32			AkTimeMs;			 		///< Time in ms
  typedef AkUInt16		AkPortNumber;				///< Port number
  typedef AkReal32		AkPitchValue;		 		///< Pitch value
  typedef AkReal32		AkVolumeValue;		 		///< Volume value( also apply to LFE )
  typedef AkUInt64		AkGameObjectID;		 		///< Game object ID
  typedef AkReal32		AkLPFType;			 		///< Low-pass filter type
  typedef AkInt32			AkMemPoolId;		 		///< Memory pool ID
  typedef AkUInt32		AkPluginID;			 		///< Source or effect plug-in ID
  typedef AkUInt32		AkCodecID;			 		///< Codec plug-in ID
  typedef AkUInt32		AkAuxBusID;			 		///< Auxilliary bus ID
  typedef AkInt16			AkPluginParamID;	 		///< Source or effect plug-in parameter ID
  typedef AkInt8			AkPriority;			 		///< Priority
  typedef AkUInt16        AkDataCompID;		 		///< Data compression format ID
  typedef AkUInt16        AkDataTypeID;		 		///< Data sample type ID
  typedef AkUInt8			AkDataInterleaveID;	 		///< Data interleaved state ID
  typedef AkUInt32        AkSwitchGroupID;	 		///< Switch group ID
  typedef AkUInt32        AkSwitchStateID;	 		///< Switch ID
  typedef AkUInt32        AkRtpcID;			 		///< Real time parameter control ID
  typedef AkReal32        AkRtpcValue;		 		///< Real time parameter control value
  typedef AkUInt32        AkBankID;			 		///< Run time bank ID
  typedef AkUInt32        AkFileID;			 		///< Integer-type file identifier
  typedef AkUInt32        AkDeviceID;			 		///< I/O device ID
  typedef AkUInt32		AkTriggerID;		 		///< Trigger ID
  typedef AkUInt32		AkArgumentValueID;			///< Argument value ID
  typedef AkUInt32		AkChannelMask;				///< Channel mask (similar to WAVE_FORMAT_EXTENSIBLE). Bit values are defined in AkSpeakerConfig.h.
  typedef AkUInt32		AkModulatorID;				///< Modulator ID
  typedef AkUInt32		AkAcousticTextureID;		///< Acoustic Texture ID
  typedef AkUInt32		AkImageSourceID;			///< Image Source ID
  
  
   AKRESULT AK_SOUNDDLL_Init(bool connect_to_wwise);
   void     AK_SOUNDDLL_Term();

   void     AK_SOUNDDLL_Tick();

  // File system interface.
   AKRESULT AK_SOUNDDLL_SetBasePath(
    const AkOSChar*   in_pszBasePath
    );
   AKRESULT AK_SOUNDDLL_SetBankPath(
    const AkOSChar*   in_pszBankPath
    );
   AKRESULT AK_SOUNDDLL_SetAudioSrcPath(
    const AkOSChar*   in_pszAudioSrcPath
    );
   AKRESULT AK_SOUNDDLL_SetLangSpecificDirName(
    const AkOSChar*   in_pszDirName
    );

   AKRESULT AK_SOUNDDLL_InitPlugins();

  
    AKRESULT AK_SOUNDDLL_LoadBank(const char *name, AkMemPoolId id, AkBankID &outBankId);

  
    AKRESULT AK_SOUNDDLL_RegisterGameObj(AkGameObjectID gameObjectID);

  
    AKRESULT AK_SOUNDDLL_RegisterGameObjName(AkGameObjectID gameObjectID, const char *name);

  
    AKRESULT AK_SOUNDDLL_UnregisterGameObj(AkGameObjectID id);

  
    AkPlayingID AK_SOUNDDLL_PostEvent(const char *name, AkGameObjectID id);

  
    void AK_SOUNDDLL_StopPlayingID(AkPlayingID id, AkTimeMs transDur);

  
    AKRESULT AK_SOUNDDLL_SetRTPCValue(const char *name, AkRtpcValue value, AkGameObjectID id);

  
    AKRESULT AK_SOUNDDLL_SetRTPCValueGlobal(const char *name, AkRtpcValue value);

  
    AKRESULT AK_SOUNDDLL_SetSwitch(const char *switchGroup, const char *switchState, AkGameObjectID id);

  
    AKRESULT AK_SOUNDDLL_SetState(const char *stateGroup, const char *state);

    AKRESULT AK_SOUNDDLL_SeekEvent(AkUniqueID id, AkGameObjectID gObjId, AkTimeMs pos);

    AkUniqueID AK_SOUNDDLL_GetEventIdFromPlayingId(AkPlayingID id);

    AkTimeMs AK_SOUNDDLL_GetSourceTime(AkPlayingID id);
    
  ]]
  
  wwise.lib = ffi.load("./Wwise.dll")
  wwise.lastBankID = ffi.new("AkBankID [1]")
  wwise.lastObjectID = 1
  
  
  local result = wwise.lib.AK_SOUNDDLL_Init(true)
  print("Wwise Init:", wwise.error(result))

  wwise.baseId = 9999999
  wwise.lib.AK_SOUNDDLL_RegisterGameObjName(wwise.baseId, "Base Emitter")
end

function wwise.error(result)
  local result_num = tonumber(result)
  return "(" .. result_num .. "): " .. wwise.errors[result_num + 1]
end

function wwise.update()
  wwise.lib.AK_SOUNDDLL_Tick()
end

function wwise.quit()
  wwise.lib.AK_SOUNDDLL_Term()
end

function wwise.register_gameobject()
  local id = wwise.lastObjectID
  
  local result = wwise.lib.AK_SOUNDDLL_RegisterGameObj(id)
  print("Registered gameobject" .. " (" .. wwise.error(result) .. ")")

  wwise.lastObjectID += 1
  
  return id
end

function wwise.loadBank(path)
  local result = wwise.lib.AK_SOUNDDLL_LoadBank(path, -1, wwise.lastBankID)
  --print(result)
  
  if tonumber(result) ~= 1 then
    print("Error loading bank:" .. path .. " (" .. wwise.error(result) .. ")")
  end
end

local function resolveGameobject(gameobject)
  if gameobject then
    return gameobject
  end
  
  return wwise.baseId
end

function wwise.postEvent(event, gameobject)
  --print("POST " .. event)
  local gameobject_id = resolveGameobject(gameobject)

  local result = wwise.lib.AK_SOUNDDLL_PostEvent(event, gameobject_id)
  if tonumber(result) == 0 then
    print("Error posting event:" .. event)
  end
  
  return result
end

function wwise.setSwitch(switch_group, switch_state, gameobject)
  local gameobject_id = resolveGameobject(gameobject)
  
  local result = wwise.lib.AK_SOUNDDLL_SetSwitch(switch_group, switch_state, gameobject_id)
  if tonumber(result) ~= 1 then
    print("Error setting switch:" .. switch_group .. "," .. switch_state .. "," .. gameobject_id .. " (" .. wwise.error(result) .. ")")
  end
end

function wwise.setState(state_group, state)
  local result = wwise.lib.AK_SOUNDDLL_SetState(state_group, state)
  
  if tonumber(result) ~= 1 then
    print("Error setting switch:" .. state_group .. "," .. state .. " (" .. wwise.error(result) .. ")")
  end
end

function wwise.stopPlayingID(id, transTime)
  transTime = transTime or 0
  
  wwise.lib.AK_SOUNDDLL_StopPlayingID(id, transTime)
  --if tonumber(result) ~= 1 then
  --  print("Error stopping id:" .. id .. "," .. transTime .. " (" .. wwise.error(result) .. ")")
  --end
end

function wwise.getEventId(playId)
  return wwise.lib.AK_SOUNDDLL_GetEventIdFromPlayingId(playId)
end

function wwise.getSourceTime(playId)
  return wwise.lib.AK_SOUNDDLL_GetSourceTime(playId)
end

function wwise.seekEvent(id, timeMs, gameobject)
  --print("SEEK " .. timeMs)

  local gameobject_id = resolveGameobject(gameobject)
  local evt_id = wwise.getEventId(id)

  wwise.lib.AK_SOUNDDLL_SeekEvent(evt_id, gameobject_id, timeMs)
end
