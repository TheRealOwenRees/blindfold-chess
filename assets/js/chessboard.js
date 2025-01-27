import { Chess } from 'chess.js';

export const ChessBoard = {
    // PROPS
    fenValue() {
        return this.el.dataset.fen;
    },
    sideValue() {
        return this.el.dataset.side;
    },

    // LIFECYCLE METHODS
    mounted() {
        this.createBoard();
        this.createGame();
    },
    updated() {
        if (this.board) this.board.destroy();
        this.createBoard();
        this.createGame();
    },
    destroyed() {
        this.board.destroy();
    },

    // HELPER METHODS
    createBoard() {
        let circle1Id = null;
        let selectedSquare1 = null;
        let selectedSquare2 = null;
        let uciMove = null;

        try {
            const config = {
                orientation: this.sideValue(),
                position: this.fenValue(),
                showNotation: true,
                onMousedownSquare: handleMouseDownSquare,
                onMouseenterSquare: handleMouseEnterSquare,
                onMouseleaveSquare: handleMouseLeaveSquare,
            }

            this.board = new Chessboard2('board1', config);
            const board = this.board;

            function handleMouseDownSquare(evt) {
                if (circle1Id) {
                    board.removeCircle(circle1Id)
                    circle1Id = null
                } else {
                    circle1Id = board.addCircle(evt)
                }

                if (!selectedSquare1) {
                    // First square selected
                    selectedSquare1 = evt.square
                    uciMove = evt.square
                } else if (selectedSquare2) {
                    // Set first square if second already selected
                    selectedSquare1 = evt.square
                    selectedSquare2 = null
                    uciMove = selectedSquare1
                } else if (evt.square === selectedSquare1) {
                    // Deselect if clicking same square
                    selectedSquare1 = null
                    uciMove = null
                } else {
                    // Second square selected
                    selectedSquare2 = evt.square
                    uciMove = selectedSquare1 + selectedSquare2
                    passUCIMoveToServer(uciMove)
                }
            }

            function passUCIMoveToServer(move) {
                console.log(move)
            }

            function handleMouseEnterSquare(evt) {
                const boardSquare = document.querySelector(`[data-square-coord=${evt.square}]`);

                // highlight the square moused over
                if (boardSquare) {
                    boardSquare.classList.add('highlight-square');
                }
            }

            function handleMouseLeaveSquare(evt) {
                const boardSquare = document.querySelector(`[data-square-coord=${evt.square}]`);

                // remove highlight from the square
                if (boardSquare) {
                    boardSquare.classList.remove('highlight-square');
                }
            }
        } catch (error) {
            console.error(error);
        }
    },
    createGame() {
        try {
            let chessGame = new Chess(this.fenValue());

            // TODO convert text input move to UCI format
            // TODO check if move is legal
            this.handleEvent("checkLegalMove", ({ move }) => {
                console.log(move)
                this.pushEvent("is_legal_move?", {
                    move: move,
                    legal: true
                })
            })

            // make a move in the chess.js game, keeping move validation up to date
            this.handleEvent("gameMove", ({ move }) => {
                console.log(move)
                chessGame.move(move);
                console.log(chessGame.ascii())
            })
        } catch (error) {
            console.error(error);
        }
    }
}