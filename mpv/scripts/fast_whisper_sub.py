import sys
import os
from faster_whisper import WhisperModel


def generate_subtitles(video_path):
    # 获取视频同名 srt 路径
    base_path, _ = os.path.splitext(video_path)
    srt_path = base_path + ".srt"

    # 如果字幕已存在则不重复生成
    if os.path.exists(srt_path):
        return

    # 初始化模型（可以根据显卡配置修改，若用 CPU 请把 cuda 改为 cpu）
    # model_size 可选: 'tiny', 'base', 'small', 'medium', 'large-v3'
    model = WhisperModel("small", device="cpu", compute_type="float16")

    print("开始生成字幕...")
    segments, info = model.transcribe(video_path, beam_size=5)

    def format_time(seconds):
        hours = int(seconds // 3600)
        minutes = int((seconds % 3600) // 60)
        secs = int(seconds % 60)
        millis = int((seconds % 1) * 1000)
        return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"

    with open(srt_path, "w", encoding="utf-8") as f:
        for i, segment in enumerate(segments, start=1):
            f.write(f"{i}\n")
            f.write(f"{format_time(segment.start)} --> {format_time(segment.end)}\n")
            f.write(f"{segment.text.strip()}\n\n")
    print("字幕生成完毕")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        generate_subtitles(sys.argv[1])
