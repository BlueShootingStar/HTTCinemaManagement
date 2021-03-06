package com.httcinema.ui.subpanel;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;
import java.awt.HeadlessException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.LayoutStyle.ComponentPlacement;
import javax.swing.border.LineBorder;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.table.DefaultTableModel;

import com.httcinema.custom_jcomponents.CustomButton;
import com.httcinema.custom_jcomponents.CustomTableStyler;
import com.httcinema.custom_jcomponents.CustomScrollPane;
import com.httcinema.custom_jcomponents.CustomTextField;
import com.httcinema.custom_jcomponents.theme.Theme;
import com.httcinema.dao.PhimDAO;
import com.httcinema.helper.DateHelper;
import com.httcinema.helper.DialogHelper;
import com.httcinema.helper.ShareHelper;
import com.httcinema.model.Phim;
import com.httcinema.ui.ChaoJPanel;
import com.httcinema.ui.ManHinhChinhJFrame;

@SuppressWarnings({ "serial", "unchecked", "rawtypes" })
public class QuanLyPhimJScrollPanelNoiDungJPanel extends JPanel {
	
	private JTable tblDanhSach;
	private JPanel pnlBang;
	private JLabel lblTimKiem;
	private CustomTextField txtTimKiem;
	private CustomButton btnThem;

	/**
	 * Create the panel.
	 */
	public QuanLyPhimJScrollPanelNoiDungJPanel() {
		setBackground(Color.WHITE);
		
		JPanel pnlTimKiem = new JPanel();
		pnlTimKiem.setBackground(Color.WHITE);
		
		pnlBang = new JPanel();
		pnlBang.setBackground(Color.WHITE);
		
		lblTimKiem = new JLabel("");
		lblTimKiem.setIcon(new ImageIcon(QuanLyGiaVeJScrollPaneNoiDungJPanel.class.getResource("/com/httcinema/icon/action-search.png")));
		
		txtTimKiem = new CustomTextField();
		txtTimKiem.setBorder(new LineBorder(new Color(46, 158, 158), 2));
		txtTimKiem.setColumns(10);
		txtTimKiem.setFont(new Font("Tahoma", Font.PLAIN, 16));
		txtTimKiem.setPlaceholder("Tìm tên phim...");
		txtTimKiem.getDocument().addDocumentListener(new DocumentListener() {
			public void changedUpdate(DocumentEvent e) {
				warn();
			}

			public void removeUpdate(DocumentEvent e) {
				warn();
			}

			public void insertUpdate(DocumentEvent e) {
				warn();
			}

			public void warn() {
				loadTable();
			}
		});
		
		btnThem = new CustomButton("Thêm");
		btnThem.setIcon(new ImageIcon(QuanLyGiaVeJScrollPaneNoiDungJPanel.class.getResource("/com/httcinema/icon/action-add.png")));
		btnThem.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				QuanLyPhimJScrollPaneNoiDungJPanelThongTinChiTietJDialog.showDialog(ManHinhChinhJFrame.frameManHinhChinh, null, QuanLyPhimJScrollPaneNoiDungJPanelThongTinChiTietJDialog.THEM);
			}
		});
		Theme.setDefaultButtonFormat(btnThem);
		btnThem.setBackground(Theme.green);
		btnThem.setHoverBackground(Theme.darkGreen);
		
		GroupLayout gl_pnlTimKiem = new GroupLayout(pnlTimKiem);
		gl_pnlTimKiem.setHorizontalGroup(
			gl_pnlTimKiem.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pnlTimKiem.createSequentialGroup()
					.addContainerGap()
					.addComponent(lblTimKiem, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED)
					.addComponent(txtTimKiem, GroupLayout.PREFERRED_SIZE, 200, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED, 310, Short.MAX_VALUE)
					.addComponent(btnThem, GroupLayout.PREFERRED_SIZE, 162, GroupLayout.PREFERRED_SIZE)
					.addContainerGap())
		);
		gl_pnlTimKiem.setVerticalGroup(
			gl_pnlTimKiem.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pnlTimKiem.createSequentialGroup()
					.addContainerGap()
					.addGroup(gl_pnlTimKiem.createParallelGroup(Alignment.LEADING)
						.addComponent(lblTimKiem, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
						.addComponent(txtTimKiem, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
						.addComponent(btnThem, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE))
					.addContainerGap(20, Short.MAX_VALUE))
		);
		pnlTimKiem.setLayout(gl_pnlTimKiem);
		
		GroupLayout gl_panel = new GroupLayout(this);
		gl_panel.setHorizontalGroup(
			gl_panel.createParallelGroup(Alignment.TRAILING)
				.addGroup(gl_panel.createSequentialGroup()
					.addContainerGap()
					.addGroup(gl_panel.createParallelGroup(Alignment.TRAILING)
						.addComponent(pnlTimKiem, Alignment.LEADING, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
						.addComponent(pnlBang, Alignment.LEADING, GroupLayout.DEFAULT_SIZE, 780, Short.MAX_VALUE))
					.addContainerGap())
		);
		gl_panel.setVerticalGroup(
			gl_panel.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_panel.createSequentialGroup()
					.addContainerGap()
					.addComponent(pnlTimKiem, GroupLayout.PREFERRED_SIZE, 71, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.UNRELATED)
					.addComponent(pnlBang, GroupLayout.DEFAULT_SIZE, 346, Short.MAX_VALUE)
					.addContainerGap())
		);

		CustomScrollPane scrollPane = new CustomScrollPane();
		tblDanhSach = new JTable() {
			boolean[] columnEditables = new boolean[] {
					false,
					false,
					false,
//					false,
					false,
					false,
					false,
					false,
//					false,
//					false,
					true,
					true
					};

			@Override
			public boolean isCellEditable(int row, int column) {
//				return false;
				return columnEditables[column];
			}
		};
		tblDanhSach.addMouseMotionListener(new MouseMotionAdapter() {
			@Override
			public void mouseMoved(MouseEvent evt) {
				if (tblDanhSach.columnAtPoint(evt.getPoint()) == tblDanhSach.getColumnCount() - 1 || tblDanhSach.columnAtPoint(evt.getPoint()) == tblDanhSach.getColumnCount() - 2) {
					tblDanhSach.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
				} else {
					tblDanhSach.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
				}
			}
		});
		tblDanhSach.setModel(new DefaultTableModel(
				new Object[][] {},
				new String[] {
						"Mã phim",
						"Hình",
						"Tên phim",
//						"Mã thể loại",
						"Nhà sản xuất",
						"Độ tuổi",
						"Thời lượng",
						"Ngày ra mắt",
//						"Trailer",
//						"Hình",
						"",
						""
						}) {
			
			public Class getColumnClass(int column)
            {
                return getValueAt(0, column).getClass();
            }
		});
		Theme.setDefaultTableFormat(tblDanhSach);
		tblDanhSach.setRowHeight(80);
		scrollPane.setViewportView(tblDanhSach);

		GroupLayout gl_pnlBang = new GroupLayout(pnlBang);
		gl_pnlBang.setHorizontalGroup(
				gl_pnlBang.createParallelGroup(Alignment.LEADING).addGroup(gl_pnlBang.createSequentialGroup().addGap(10)
						.addComponent(scrollPane, GroupLayout.DEFAULT_SIZE, 703, Short.MAX_VALUE).addGap(10)));
		gl_pnlBang.setVerticalGroup(
				gl_pnlBang.createParallelGroup(Alignment.LEADING).addGroup(gl_pnlBang.createSequentialGroup().addGap(11)
						.addComponent(scrollPane, GroupLayout.DEFAULT_SIZE, 370, Short.MAX_VALUE).addGap(11)));
		pnlBang.setLayout(gl_pnlBang);
		setLayout(gl_panel);
		
		loadTable();
	}
	
	private void loadTable() {
		DefaultTableModel model = (DefaultTableModel) tblDanhSach.getModel();
		model.setRowCount(0);
		
        try {
        	String keyword = txtTimKiem.getText();
			List<Phim> list = new PhimDAO().selectByKeyword(keyword);
            for (Phim phim : list) {
				Icon copyIcon = new ImageIcon(ShareHelper.readMovieImage(phim, 50, 60));
            	
                Object[] row = {
            		phim.getMaPhim(),
            		copyIcon,
            		phim.getTenPhim(),
//            		phim.getMaTheLoai(),
            		phim.getNhaSanXuat(),
            		phim.getDoTuoi() > 1 ? phim.getDoTuoi() + "+" : "Mọi lứa tuổi",
            		phim.getThoiLuong() + " phút",
            		DateHelper.toString(phim.getNgayCongChieu(), "dd-MM-yyyy (EEE)"),
//            		phim.getTrailer(),
//            		phim.getHinh(),
            		new ImageIcon(ChaoJPanel.class.getResource("/com/httcinema/icon/action-delete.png")),
            		new ImageIcon(ChaoJPanel.class.getResource("/com/httcinema/icon/action-edit.png"))
		        };
		        model.addRow(row);
            }
            
            // biến 2 cột cuối cùng thành hai nút xóa và cập nhật
            new CustomTableStyler(tblDanhSach, delete, tblDanhSach.getColumnCount() - 2, Theme.danger, Theme.darkDanger);
            new CustomTableStyler(tblDanhSach, edit, tblDanhSach.getColumnCount() - 1, Theme.success, Theme.darkSuccess);

            tblDanhSach.getColumnModel().getColumn(3).setMinWidth(100);
			tblDanhSach.getColumnModel().getColumn(6).setMinWidth(100);
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
	/**
	 * this object is for deleting data from database
	 */
	Action delete = new AbstractAction() {
		public void actionPerformed(ActionEvent e) {
			int modelRow = Integer.valueOf(e.getActionCommand());
			
			String primaryKey = String.valueOf(tblDanhSach.getValueAt(modelRow, 0));
			if (new PhimDAO().findInTicket(primaryKey) != null) {
				DialogHelper.error(ManHinhChinhJFrame.frameManHinhChinh, "Phim này đã có người mua vé!");
				return;
			}
			
			if (DialogHelper.confirm(ManHinhChinhJFrame.frameManHinhChinh, "Bạn thực sự muốn xóa?")) {
				try {
					new PhimDAO().delete(primaryKey);
					ShareHelper.refreshAllTable();
					DialogHelper.success(ManHinhChinhJFrame.frameManHinhChinh, "Xóa thành công!");
				} catch (HeadlessException ex) {
					DialogHelper.error(ManHinhChinhJFrame.frameManHinhChinh, "Xóa thất bại!");
				}
			}
		}
	};
	
	/**
	 * this object is for action in edit button
	 */
	Action edit = new AbstractAction() {
		public void actionPerformed(ActionEvent e) {
			int modelRow = Integer.valueOf(e.getActionCommand());
			
			String primaryKey = String.valueOf(tblDanhSach.getValueAt(modelRow, 0));
			Phim phim = new PhimDAO().findById(primaryKey + "");

			if (new PhimDAO().findInTicket(primaryKey) != null) {
				QuanLyPhimJScrollPaneNoiDungJPanelThongTinChiTietJDialog.showDialog(ManHinhChinhJFrame.frameManHinhChinh, phim, QuanLyPhimJScrollPaneNoiDungJPanelThongTinChiTietJDialog.XEM_CHI_TIET);
				return;
			}
			
			QuanLyPhimJScrollPaneNoiDungJPanelThongTinChiTietJDialog.showDialog(ManHinhChinhJFrame.frameManHinhChinh, phim, QuanLyPhimJScrollPaneNoiDungJPanelThongTinChiTietJDialog.CAP_NHAT);
		}
	};
	
	public void refreshAll() {
		loadTable();
	}
}
