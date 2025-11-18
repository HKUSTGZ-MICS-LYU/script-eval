# 文件名: convert_gds.py (已修正)
import gdstk
import cairosvg
import sys
import os

if len(sys.argv) != 3:
    print(f"用法: python {sys.argv[0]} <input.gds> <output.png>")
    sys.exit(1)

gds_file = sys.argv[1]
png_file = sys.argv[2]
svg_file = "temp_layout_intermediate.svg" # 临时 SVG 文件

# --- 1. 加载 GDSII 文件 ---
print(f"正在加载 {gds_file}...")
try:
    lib = gdstk.read_gds(gds_file)
except Exception as e:
    print(f"错误: 无法读取 GDSII 文件. {e}")
    sys.exit(1)

# --- 2. 找到顶层单元并导出到 SVG ---
top_cells = lib.top_level()
if not top_cells:
    print("错误: 在 GDSII 中未找到顶层单元。")
    sys.exit(1)

main_cell = top_cells[0]
print(f"找到顶层单元: {main_cell.name}. 正在导出到 SVG...")

# 导出 SVG。使用修正后的 background 参数
try:
    main_cell.write_svg(svg_file, background='#000000')
except TypeError:
    # 为非常旧的 gdstk 版本提供降级方案
    print("警告: 'background' 参数无效。尝试无背景色导出。")
    main_cell.write_svg(svg_file, padding=10)

# --- 3. 将 SVG 转换为 PNG ---
print(f"正在转换 SVG 到 {png_file}...")
try:
    cairosvg.svg2png(
        url=svg_file,
        write_to=png_file,
        output_width=4096,  # 设置期望的 PNG 宽度
        output_height=4096, # 设置期望的 PNG 高度
        parent_width=4096,
        parent_height=4096
    )
except Exception as e:
    print(f"错误: 无法转换 SVG 到 PNG. {e}")
    sys.exit(1)
finally:
    # --- 4. 清理临时的 SVG 文件 ---
    if os.path.exists(svg_file):
        os.remove(svg_file)

print(f"转换成功！图片已保存到: {png_file}")